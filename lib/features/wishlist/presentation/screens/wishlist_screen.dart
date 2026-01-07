import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:provider/provider.dart';

import '../../../../core/di/riverpod_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/shimmer/product/product_grid_shimmer.dart';
import '../../../../core/widgets/shimmer/product/product_list_shimmer.dart';

import '../../../home/presentation/widgets/category_bar_entity.dart';
import '../../../offline/presentation/screens/offline_screen.dart';

import '../../../product/domain/entities/product.dart';
import '../../../product/presentation/controllers/product_controller.dart';
import '../../../product/presentation/widgets/product_grid_entity.dart';

import '../notifiers/wishlist_notifier.dart';

class WishlistScreen extends rp.ConsumerStatefulWidget {
  const WishlistScreen({super.key});

  @override
  rp.ConsumerState<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends rp.ConsumerState<WishlistScreen> {
  bool _isCategoryChanging = false;
  bool _isCheckingInternet = true;
  bool _isOnline = true;
  bool _showShimmer = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _checkInternetConnection() async {
    if (mounted) setState(() => _isCheckingInternet = true);

    try {
      final connectivityService = ref.read(connectivityServiceProvider);
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

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() => _showShimmer = false);
    await _checkInternetConnection();
  }

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productController = context.read<ProductController>();

      if (!productController.categoriesLoaded) {
        productController.loadCategories();
      }
      ref.read(wishlistNotifierProvider.notifier).load();
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

    final productController = context.watch<ProductController>();
    final selectedCategoryName = productController.selectedCategoryName;

    if (!_isOnline) {
      return OfflineScreen(onRetry: _checkInternetConnection);
    }

    if (_isCheckingInternet || _showShimmer) {
      return ProductListShimmer(isLightMode: isLightMode);
    }

    final wishlistState = ref.watch(wishlistNotifierProvider);

    ref.listen(wishlistNotifierProvider.select((s) => s.error), (prev, next) {
      if (next == null || next.isEmpty) return;
      if (next == prev) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next)));
    });

    final allWishlistProducts = wishlistState.items.map((e) => e.product).toList();

    final List<Product> filteredWishlistProducts = selectedCategoryName == null
        ? allWishlistProducts
        : allWishlistProducts.where((p) => p.category.name == selectedCategoryName).toList();

    if (wishlistState.isLoading && allWishlistProducts.isEmpty) {
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
                colorFilter: ColorFilter.mode(
                  isLightMode ? AppColors.grey900 : AppColors.white,
                  BlendMode.srcIn,
                ),
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
              CategoryBarEntity(indexCategory: -1, onCategoryChanged: _onCategoryChanged),
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
                ProductGridEntity(isLightMode: isLightMode, products: filteredWishlistProducts),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
            ],
          ),
        ),
      ),
    );
  }
}
