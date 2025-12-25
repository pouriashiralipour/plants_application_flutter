import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:full_plants_ecommerce_app/core/utils/persian_number.dart';
import 'package:full_plants_ecommerce_app/core/utils/price_formatter.dart';
import 'package:provider/provider.dart';

import '../../../cart/presentation/controllers/cart_controller.dart';
import '../../domain/usecases/get_product_by_id.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/app_alert_dialog.dart';
import '../../../../core/widgets/app_progress_indicator.dart';
import '../../../../core/widgets/gap.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/shimmer/product/product_card_shimmer.dart';
import '../../../../core/widgets/shimmer/product/product_screen_shimmer.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../wishlist/presentation/controllers/wishlist_controller.dart';
import '../../../offline/presentation/screens/offline_screen.dart';
import '../controllers/product_details_controller.dart';
import '../../domain/entities/product.dart';
import '../../../../core/widgets/login_required_sheet.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import '../../../auth/presentation/screens/login_screen.dart';

import 'review_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, required this.productId});

  final String productId;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  PageController pageController = PageController(initialPage: 0);

  late final ProductDetailsController _detailsController;

  bool _cartIsError = false;
  bool _isAddingToCart = false;
  bool _isCheckingInternet = true;
  bool _isOnline = true;
  int _quantity = 1;
  int _selectedImage = 0;

  String? _cartMessage;

  @override
  void dispose() {
    pageController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _detailsController = ProductDetailsController(getProductById: context.read<GetProductById>());
    _initializeApp();
  }

  Widget _buildDescriptionSection(
    Product product,
    String shortDescription,
    bool hasLongDescription,
    bool isLightMode,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'توضیحات',
          style: TextStyle(
            color: isLightMode ? AppColors.grey900 : AppColors.white,
            fontSize: SizeConfig.getProportionateFontSize(16),
            fontWeight: FontWeight.w700,
          ),
        ),
        Gap(SizeConfig.getProportionateScreenHeight(8)),
        Text(
          shortDescription,
          style: TextStyle(
            color: isLightMode ? AppColors.grey800 : AppColors.grey300,
            fontSize: SizeConfig.getProportionateFontSize(13),
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
        ),

        if (hasLongDescription)
          GestureDetector(
            onTap: () => _showDescriptionModal(context, product.description),
            child: Container(
              margin: EdgeInsets.only(top: 8),
              child: Text(
                'مشاهده بیشتر',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: SizeConfig.getProportionateFontSize(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImageGallery(Product product, bool isLightMode) {
    return Container(
      width: double.infinity,
      color: isLightMode ? AppColors.bgSilver1 : AppColors.dark1,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: product.images.length,
            controller: pageController,
            scrollDirection: Axis.horizontal,
            onPageChanged: (int page) {
              setState(() {
                _selectedImage = page;
              });
            },
            itemBuilder: (context, index) {
              final image = product.images[index].image;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: SizeConfig.getProportionateScreenHeight(280),
                    width: SizeConfig.getProportionateScreenWidth(280),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.withValues(alpha: 0.5),
                        //     spreadRadius: 1,
                        //     blurRadius: 7,
                        //     offset: Offset(0, 3),
                        //   ),
                        // ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.getProportionateScreenHeight(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(product.images.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    margin: EdgeInsets.only(right: SizeConfig.getProportionateScreenWidth(6)),
                    width: _selectedImage == index
                        ? SizeConfig.getProportionateScreenWidth(32)
                        : SizeConfig.getProportionateScreenWidth(8),
                    height: SizeConfig.getProportionateScreenWidth(8),
                    decoration: BoxDecoration(
                      gradient: _selectedImage == index ? AppColors.gradientGreen : null,
                      borderRadius: BorderRadius.circular(8),
                      color: _selectedImage != index
                          ? (isLightMode ? AppColors.grey300 : AppColors.dark3)
                          : null,
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceAndButtonSection(Product product, bool isLightMode) {
    return Consumer<CartController>(
      builder: (context, cart, _) {
        final totalPrice = _quantity * _displayPrice(product);
        final isLoading = _isAddingToCart;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_cartMessage != null) ...[
              Padding(
                padding: EdgeInsets.only(bottom: SizeConfig.getProportionateScreenHeight(12)),
                child: AppAlertDialog(text: _cartMessage!, isError: _cartIsError),
              ),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isLoading
                    ? SizedBox(
                        width: SizeConfig.screenWidth * 0.6,
                        height: SizeConfig.getProportionateScreenHeight(48),
                        child: const Center(child: AppProgressBarIndicator()),
                      )
                    : AppButton(
                        onTap: () async {
                          setState(() {
                            _cartMessage = null;
                            _cartIsError = false;
                            _isAddingToCart = true;
                          });

                          final startedAt = DateTime.now();

                          await context.read<CartController>().addItem(
                            productId: product.id,
                            quantity: _quantity,
                          );

                          if (!mounted) return;

                          final cartRepo = context.read<CartController>();

                          final elapsed = DateTime.now().difference(startedAt);
                          const minDuration = Duration(seconds: 1);
                          if (elapsed < minDuration) {
                            await Future.delayed(minDuration - elapsed);
                          }

                          if (!mounted) return;

                          if (cartRepo.error != null) {
                            _showCartMessage(cartRepo.error!, isError: true);
                          } else {
                            _showCartMessage('محصول به سبد خرید اضافه شد.');
                          }

                          setState(() {
                            _isAddingToCart = false;
                          });
                        },
                        text: 'افزودن به سبد خرید',
                        color: AppColors.primary,
                        width: SizeConfig.screenWidth * 0.6,
                        is_icon: true,
                        fontSize: SizeConfig.getProportionateFontSize(13),
                      ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'قیمت',
                      style: TextStyle(
                        color: isLightMode ? AppColors.grey600 : AppColors.grey400,
                        fontSize: SizeConfig.getProportionateFontSize(12),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${totalPrice.toString().priceFormatter} تومان'.farsiNumber,
                      style: TextStyle(
                        color: isLightMode ? AppColors.grey900 : AppColors.white,
                        fontSize: SizeConfig.getProportionateFontSize(14),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildProductInfo(
    Product product,
    String shortDescription,
    bool hasLongDescription,
    bool isLightMode,
    bool isFav,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.getProportionateScreenWidth(24),
        vertical: SizeConfig.getProportionateScreenWidth(12),
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isLightMode ? AppColors.white : AppColors.dark2,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(36),
          topLeft: Radius.circular(36),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: TextStyle(
                            fontSize: SizeConfig.getProportionateFontSize(18),
                            color: isLightMode ? AppColors.grey900 : AppColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final isAuthed = context.read<AuthRepository>().isAuthed;

                          if (!isAuthed) {
                            final goLogin = await showLoginRequiredSheet(
                              context: context,
                              title: 'علاقه‌مندی‌ها',
                              message:
                                  'برای افزودن یا حذف از علاقه‌مندی‌ها ابتدا وارد حساب کاربری شوید.',
                              icon: 'assets/images/icons/HeartBold.svg',
                              loginText: 'ورود / ثبت‌نام',
                              cancelText: 'بعداً',
                            );

                            if (goLogin == true && mounted) {
                              await Navigator.push<bool>(
                                context,
                                MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (_) => const LoginScreen(),
                                ),
                              );

                              if (!mounted) return;

                              if (context.read<AuthRepository>().isAuthed) {
                                context.read<WishlistController>().toggle(product.id);
                              }
                            }
                            return;
                          }

                          context.read<WishlistController>().toggle(product.id);
                        },

                        icon: SvgPicture.asset(
                          isFav
                              ? 'assets/images/icons/HeartBold.svg'
                              : 'assets/images/icons/Heart_outline.svg',
                          colorFilter: .mode(AppColors.primary, .srcIn),
                        ),
                      ),
                    ],
                  ),

                  Gap(SizeConfig.getProportionateScreenHeight(16)),

                  _buildRatingAndSales(product, isLightMode),

                  Gap(SizeConfig.getProportionateScreenHeight(16)),
                  Divider(color: AppColors.grey200, thickness: 2),
                  Gap(SizeConfig.getProportionateScreenHeight(10)),

                  _buildDescriptionSection(
                    product,
                    shortDescription,
                    hasLongDescription,
                    isLightMode,
                  ),

                  Gap(SizeConfig.getProportionateScreenHeight(10)),

                  _buildQuantitySection(isLightMode),
                ],
              ),
            ),
          ),

          Gap(SizeConfig.getProportionateScreenHeight(10)),
          Divider(color: AppColors.grey200, thickness: 2),
          Gap(SizeConfig.getProportionateScreenHeight(10)),

          _buildPriceAndButtonSection(product, isLightMode),
        ],
      ),
    );
  }

  Widget _buildQuantitySection(bool isLightMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'تعداد',
          style: TextStyle(
            color: isLightMode ? AppColors.grey900 : AppColors.white,
            fontSize: SizeConfig.getProportionateFontSize(18),
            fontWeight: FontWeight.w700,
          ),
        ),
        Container(
          width: SizeConfig.getProportionateScreenWidth(128),
          height: SizeConfig.getProportionateScreenHeight(40),
          decoration: BoxDecoration(
            color: isLightMode ? AppColors.bgSilver1 : AppColors.dark3,
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _decrementQuantity,
                icon: Icon(
                  Icons.remove,
                  size: 24,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Container(
                width: 40,
                child: Center(
                  child: Text(
                    _quantity.toString().farsiNumber,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                      fontSize: SizeConfig.getProportionateFontSize(20),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: _incrementQuantity,
                icon: Icon(
                  Icons.add,
                  size: 24,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingAndSales(Product product, bool isLightMode) {
    return Row(
      children: [
        Container(
          width: SizeConfig.getProportionateScreenWidth(69),
          height: SizeConfig.getProportionateScreenHeight(24),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.primary, width: 1),
          ),
          child: Text(
            '${product.salesCount.toString().priceFormatter} فروش'.farsiNumber,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: SizeConfig.getProportionateFontSize(12),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: SizeConfig.getProportionateScreenWidth(15)),
        SvgPicture.asset(
          'assets/images/icons/Star.svg',
          colorFilter: .mode(AppColors.primary, .srcIn),
          width: SizeConfig.getProportionateScreenWidth(20),
          height: SizeConfig.getProportionateScreenWidth(20),
        ),
        SizedBox(width: SizeConfig.getProportionateScreenWidth(10)),
        Text(
          product.averageRating.toString().farsiNumber,
          style: TextStyle(
            color: isLightMode ? AppColors.grey700 : AppColors.grey300,
            fontSize: SizeConfig.getProportionateFontSize(14),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: SizeConfig.getProportionateScreenWidth(15)),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReviewScreen(
                  productId: product.id,
                  averageRating: product.averageRating,
                  totalReviews: product.totalReviews,
                ),
              ),
            );
          },
          child: Text(
            '( ${product.totalReviews.toString().priceFormatter} نظر )'.farsiNumber,
            style: TextStyle(
              color: isLightMode ? AppColors.grey700 : AppColors.grey300,
              fontSize: SizeConfig.getProportionateFontSize(12),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _checkInternetConnection() async {
    if (mounted) {
      setState(() {
        _isCheckingInternet = true;
      });
    }

    try {
      final connectivityService = context.read<ConnectivityService>();
      final isConnected = await connectivityService.checkInternetConnection();

      if (mounted) {
        setState(() {
          _isOnline = isConnected;
          _isCheckingInternet = false;
        });
      }

      if (isConnected && mounted) {
        _detailsController.load(widget.productId);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isOnline = false;
          _isCheckingInternet = false;
        });
      }
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  int _displayPrice(Product product) => product.price ~/ 10;

  String _getShortDescription(String description) {
    final words = description.split(' ');
    if (words.length <= 20) {
      return description;
    }
    return '${words.take(20).join(' ')}...';
  }

  bool _hasLongDescription(String description) {
    return description.split(' ').length > 50;
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  Future<void> _initializeApp() async {
    await Future.delayed(Duration(seconds: 1));
    if (!mounted) return;
    await _checkInternetConnection();
  }

  void _showCartMessage(String message, {bool isError = false}) {
    if (!mounted) return;

    setState(() {
      _cartMessage = message;
      _cartIsError = isError;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        _cartMessage = null;
      });
    });
  }

  void _showDescriptionModal(BuildContext context, String description) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? AppColors.white
                : AppColors.dark1,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).brightness == Brightness.light
                          ? AppColors.grey200
                          : AppColors.dark3,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)),
                    Text(
                      'توضیحات کامل محصول',
                      style: TextStyle(
                        fontSize: SizeConfig.getProportionateFontSize(16),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: SizeConfig.getProportionateScreenWidth(48)),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(16)),
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: SizeConfig.getProportionateFontSize(14),
                      height: 1.2,
                      color: Theme.of(context).brightness == Brightness.light
                          ? AppColors.grey800
                          : AppColors.grey300,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    if (!_isOnline) {
      return OfflineScreen(
        onRetry: () {
          _checkInternetConnection();
        },
      );
    }
    if (_isCheckingInternet) {
      return ProductScreenShimmer();
    }

    return ChangeNotifierProvider<ProductDetailsController>.value(
      value: _detailsController,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: isLightMode ? AppColors.bgSilver1 : AppColors.dark1,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: isLightMode ? AppColors.grey900 : AppColors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Consumer<ProductDetailsController>(
            builder: (context, details, _) {
              if (details.isLoading && details.product == null) {
                return ProductScreenShimmer();
              }

              if (details.error != null && details.product == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: AppColors.grey500),
                      const SizedBox(height: 16),
                      Text(
                        'خطا در دریافت اطلاعات محصول',
                        style: TextStyle(
                          fontSize: SizeConfig.getProportionateFontSize(16),
                          color: isLightMode ? AppColors.grey700 : AppColors.grey300,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.getProportionateScreenWidth(24),
                        ),
                        child: Text(
                          details.error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: SizeConfig.getProportionateFontSize(12),
                            color: isLightMode ? AppColors.grey600 : AppColors.grey400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          _detailsController.load(widget.productId);
                        },
                        child: const Text('تلاش مجدد'),
                      ),
                    ],
                  ),
                );
              }

              final product = details.product;
              if (product == null) {
                return ProductScreenShimmer();
              }

              final shortDescription = _getShortDescription(product.description);
              final hasLongDescription = _hasLongDescription(product.description);

              final isFav = context.watch<WishlistController>().isWishlisted(product.id);

              return Column(
                children: [
                  if (product.images.isEmpty) ProductCardShimmer(isLightMode: isLightMode),

                  SizedBox(
                    height: SizeConfig.screenHeight * 0.4,
                    child: _buildImageGallery(product, isLightMode),
                  ),

                  Expanded(
                    child: _buildProductInfo(
                      product,
                      shortDescription,
                      hasLongDescription,
                      isLightMode,
                      isFav,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
