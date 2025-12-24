import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:full_plants_ecommerce_app/core/utils/persian_number.dart';
import 'package:full_plants_ecommerce_app/core/utils/price_formatter.dart';

import '../../../../core/services/connectivity_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/shimmer/product/product_grid_shimmer.dart';
import '../../../../core/widgets/shimmer/product/product_list_shimmer.dart';

import '../../../home/presentation/widgets/custom_category_bar.dart';
import '../../../offline/presentation/screens/offline_screen.dart';

import '../../../product/data/repositories/product_repository.dart';
import '../../../product/presentation/screens/product_details_screen.dart';

import '../../domain/entities/wishlist_product.dart';
import '../controllers/wishlist_controller.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  bool _isCategoryChanging = false;
  bool _isCheckingInternet = true;
  bool _isOnline = true;
  bool _showShimmer = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() => _showShimmer = false);
    await _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    if (mounted) setState(() => _isCheckingInternet = true);

    try {
      final connectivityService = context.read<ConnectivityService>();
      final isConnected = await connectivityService.checkInternetConnection();

      if (!mounted) return;

      setState(() {
        _isOnline = isConnected;
        _isCheckingInternet = false;
      });

      if (isConnected) _loadData();
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isOnline = false;
        _isCheckingInternet = false;
      });
    }
  }

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final shopRepository = context.read<ShopRepository>();
      final wishlist = context.read<WishlistController>();

      if (!shopRepository.categoriesLoaded) {
        shopRepository.loadCategories();
      }

      wishlist.load();
    });
  }

  void _onCategoryChanged() {
    setState(() => _isCategoryChanging = true);

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isCategoryChanging = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;

    final shopRepository = context.watch<ShopRepository>();
    final wishlist = context.watch<WishlistController>();

    final selectedCategoryName = shopRepository.selectedCategoryName;

    final allWishlistProducts = wishlist.items.map((e) => e.product).toList();

    final List<WishlistProduct> filteredWishlistProducts = selectedCategoryName == null
        ? allWishlistProducts
        : allWishlistProducts.where((p) => p.categoryName == selectedCategoryName).toList();

    if (!_isOnline) {
      return OfflineScreen(onRetry: _checkInternetConnection);
    }

    if (_isCheckingInternet ||
        _showShimmer ||
        (wishlist.isLoading && allWishlistProducts.isEmpty)) {
      return ProductListShimmer(isLightMode: isLightMode);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'علاقه مندی ها',
          style: TextStyle(
            color: isLightMode ? AppColors.grey900 : AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: SizeConfig.getProportionateScreenWidth(24),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.getProportionateScreenWidth(5)),
            child: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/images/icons/Search.svg",
                color: isLightMode ? AppColors.grey900 : AppColors.white,
                width: SizeConfig.getProportionateScreenWidth(24),
                height: SizeConfig.getProportionateScreenWidth(24),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
              CustomCategoryBar(indexCategory: -1, onCategoryChanged: _onCategoryChanged),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),

              if (filteredWishlistProducts.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: SizeConfig.getProportionateScreenHeight(40)),
                  child: Center(
                    child: Text(
                      'هنوز محصولی به لیست علاقه‌مندی‌ها اضافه نکردی.',
                      style: TextStyle(
                        color: isLightMode ? AppColors.grey600 : AppColors.grey200,
                        fontSize: SizeConfig.getProportionateFontSize(13),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              else if (_isCategoryChanging)
                ProductGridShimmer(isLightMode: isLightMode)
              else
                _WishlistGrid(
                  isLightMode: isLightMode,
                  products: filteredWishlistProducts,
                  onOpenDetails: (id) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProductScreen(productId: id)),
                    );
                  },
                  onToggle: (id) => context.read<WishlistController>().toggle(id),
                ),

              SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
            ],
          ),
        ),
      ),
    );
  }
}

class _WishlistGrid extends StatelessWidget {
  const _WishlistGrid({
    required this.isLightMode,
    required this.products,
    required this.onOpenDetails,
    required this.onToggle,
  });

  final bool isLightMode;
  final List<WishlistProduct> products;
  final void Function(String productId) onOpenDetails;
  final Future<void> Function(String productId) onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.getProportionateScreenWidth(16)),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: SizeConfig.getProportionateScreenHeight(14),
          crossAxisSpacing: SizeConfig.getProportionateScreenWidth(12),
          childAspectRatio: 0.72,
        ),
        itemBuilder: (context, index) {
          final p = products[index];

          final unitPriceToman = p.price ~/ 10;

          return InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => onOpenDetails(p.id),
            child: Container(
              decoration: BoxDecoration(
                color: isLightMode ? AppColors.white : AppColors.dark2,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isLightMode ? 0.06 : 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1.15,
                      child: p.image.isEmpty
                          ? Container(
                              color: isLightMode ? AppColors.bgSilver1 : AppColors.dark3,
                              child: const Center(child: Icon(Icons.image_not_supported)),
                            )
                          : Image.network(
                              p.image,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: isLightMode ? AppColors.bgSilver1 : AppColors.dark3,
                                child: const Center(child: Icon(Icons.broken_image)),
                              ),
                            ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.getProportionateScreenWidth(10),
                      vertical: SizeConfig.getProportionateScreenHeight(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                p.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isLightMode ? AppColors.grey900 : AppColors.white,
                                  fontSize: SizeConfig.getProportionateFontSize(12),
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            SizedBox(width: SizeConfig.getProportionateScreenWidth(6)),
                            InkWell(
                              onTap: () => onToggle(p.id),
                              child: SvgPicture.asset(
                                'assets/images/icons/HeartBold.svg',
                                color: AppColors.primary,
                                width: SizeConfig.getProportionateScreenWidth(18),
                                height: SizeConfig.getProportionateScreenWidth(18),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: SizeConfig.getProportionateScreenHeight(6)),

                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/icons/Star.svg',
                              color: AppColors.primary,
                              width: SizeConfig.getProportionateScreenWidth(14),
                              height: SizeConfig.getProportionateScreenWidth(14),
                            ),
                            SizedBox(width: SizeConfig.getProportionateScreenWidth(6)),
                            Text(
                              p.averageRating.toString().farsiNumber,
                              style: TextStyle(
                                color: isLightMode ? AppColors.grey700 : AppColors.grey300,
                                fontSize: SizeConfig.getProportionateFontSize(11),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: SizeConfig.getProportionateScreenWidth(10)),
                            Text(
                              '${p.salesCount.toString().priceFormatter} فروش'.farsiNumber,
                              style: TextStyle(
                                color: isLightMode ? AppColors.grey600 : AppColors.grey400,
                                fontSize: SizeConfig.getProportionateFontSize(10),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: SizeConfig.getProportionateScreenHeight(8)),

                        Text(
                          '${unitPriceToman.toString().priceFormatter} تومان'.farsiNumber,
                          style: TextStyle(
                            color: isLightMode ? AppColors.grey900 : AppColors.white,
                            fontSize: SizeConfig.getProportionateFontSize(12),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
