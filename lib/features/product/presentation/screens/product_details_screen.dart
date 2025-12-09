import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:full_plants_ecommerce_app/core/utils/persian_number.dart';
import 'package:full_plants_ecommerce_app/core/utils/price_formatter.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/gap.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/shimmer/product/product_card_shimmer.dart';
import '../../../../core/widgets/shimmer/product/product_screen_shimmer.dart';
import '../../data/repositories/product_repository.dart';

import '../../data/models/product_model.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/utils/size.dart';
import '../../../offline/presentation/screens/offline_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, required this.productId});

  final String productId;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  PageController pageController = PageController(initialPage: 0);

  bool _isCheckingInternet = true;
  bool _isOnline = true;
  int _quantity = 1;
  int _selectedImage = 0;
  bool _showShimmer = true;

  late Future<ProductModel?> _productFuture;

  @override
  void initState() {
    super.initState();
    _initializeApp();
    _productFuture = _loadProduct();
  }

  Widget _buildDescriptionSection(
    ProductModel product,
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
        Gap(SizeConfig.getProportionateScreenHeight(10)),
        Text(
          shortDescription,
          style: TextStyle(
            color: isLightMode ? AppColors.grey800 : AppColors.grey300,
            fontSize: SizeConfig.getProportionateFontSize(14),
            fontWeight: FontWeight.w400,
            height: 1.6,
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

  Widget _buildImageGallery(ProductModel product, bool isLightMode) {
    return Container(
      height: SizeConfig.screenHeight * 0.3,
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
                    height: SizeConfig.getProportionateScreenHeight(200),
                    width: SizeConfig.getProportionateScreenWidth(200),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
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

  Widget _buildPriceAndButtonSection(ProductModel product, bool isLightMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppButton(
          onTap: () {},
          text: 'اضافه کردن به سبد خرید',
          color: AppColors.primary,
          width: SizeConfig.screenWidth * 0.5,
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
              '${(_quantity * product.price).toString().priceFormatter} ریال'.farsiNumber,
              style: TextStyle(
                color: isLightMode ? AppColors.grey900 : AppColors.white,
                fontSize: SizeConfig.getProportionateFontSize(16),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductInfo(
    ProductModel product,
    String shortDescription,
    bool hasLongDescription,
    bool isLightMode,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.getProportionateScreenWidth(24),
        vertical: SizeConfig.getProportionateScreenWidth(24),
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
              SvgPicture.asset('assets/images/icons/Heart_outline.svg', color: AppColors.primary),
            ],
          ),

          Gap(SizeConfig.getProportionateScreenHeight(20)),

          _buildRatingAndSales(product, isLightMode),

          Gap(SizeConfig.getProportionateScreenHeight(20)),
          Divider(color: AppColors.grey200, thickness: 2),
          Gap(SizeConfig.getProportionateScreenHeight(10)),

          _buildDescriptionSection(product, shortDescription, hasLongDescription, isLightMode),

          Gap(SizeConfig.getProportionateScreenHeight(10)),

          _buildQuantitySection(isLightMode),

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
          width: SizeConfig.getProportionateScreenWidth(138),
          height: SizeConfig.getProportionateScreenHeight(48),
          decoration: BoxDecoration(
            color: isLightMode ? AppColors.bgSilver1 : AppColors.dark3,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _decrementQuantity,
                icon: Icon(Icons.remove, size: 24, color: AppColors.primary),
              ),
              Container(
                width: 40,
                child: Center(
                  child: Text(
                    _quantity.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      fontSize: SizeConfig.getProportionateFontSize(20),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: _incrementQuantity,
                icon: Icon(Icons.add, size: 24, color: AppColors.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingAndSales(ProductModel product, bool isLightMode) {
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
          color: AppColors.primary,
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
        Text(
          '( ${product.salesCount.toString().priceFormatter} نظر )'.farsiNumber,
          style: TextStyle(
            color: isLightMode ? AppColors.grey700 : AppColors.grey300,
            fontSize: SizeConfig.getProportionateFontSize(12),
            fontWeight: FontWeight.w600,
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

      if (isConnected) {
        _loadProduct();
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
    if (mounted) {
      setState(() {
        _showShimmer = false;
      });
      await _checkInternetConnection();
    }
  }

  Future<ProductModel?> _loadProduct() async {
    final shopRepository = context.read<ShopRepository>();
    return await shopRepository.getProduct(widget.productId);
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isLightMode ? AppColors.bgSilver1 : AppColors.dark1,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isLightMode ? AppColors.grey900 : AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _productFuture,
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return ProductScreenShimmer();
            }

            if (asyncSnapshot.hasError || asyncSnapshot.data == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: AppColors.grey500),
                    SizedBox(height: 16),
                    Text(
                      'خطا در دریافت اطلاعات محصول',
                      style: TextStyle(
                        fontSize: SizeConfig.getProportionateFontSize(16),
                        color: isLightMode ? AppColors.grey700 : AppColors.grey300,
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _productFuture = _loadProduct();
                        });
                      },
                      child: Text('تلاش مجدد'),
                    ),
                  ],
                ),
              );
            }

            final product = asyncSnapshot.data!;
            final shortDescription = _getShortDescription(product.description);
            final hasLongDescription = _hasLongDescription(product.description);

            return SingleChildScrollView(
              child: Column(
                children: [
                  if (product.images.isEmpty) ProductCardShimmer(isLightMode: isLightMode),

                  _buildImageGallery(product, isLightMode),

                  _buildProductInfo(product, shortDescription, hasLongDescription, isLightMode),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
