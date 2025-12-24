import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/connectivity_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/shimmer/product/product_grid_shimmer.dart';
import '../../../../core/widgets/shimmer/product/product_list_shimmer.dart';
import '../../../home/presentation/widgets/custom_category_bar.dart';
import '../../../offline/presentation/screens/offline_screen.dart';
import '../../../product/data/repositories/product_repository.dart';
import '../../../product/presentation/widgets/product_grid.dart';
import '../../data/repositories/wishlist_store.dart';

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
        _loadData();
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

  Future<void> _initializeApp() async {
    await Future.delayed(Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _showShimmer = false;
      });
      await _checkInternetConnection();
    }
  }

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final shopRepository = context.read<ShopRepository>();
      final wishlistRepository = context.read<WishlistStore>();

      if (!shopRepository.categoriesLoaded) {
        shopRepository.loadCategories();
      }

      wishlistRepository.load();
    });
  }

  void _onCategoryChanged() {
    setState(() {
      _isCategoryChanging = true;
    });

    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isCategoryChanging = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    final shopRepository = context.watch<ShopRepository>();
    final wishlistRepository = context.watch<WishlistStore>();

    final allWishlistProducts = wishlistRepository.products;

    final selectedCategoryName = shopRepository.selectedCategoryName;

    final filteredWishlistProducts = selectedCategoryName == null
        ? allWishlistProducts
        : allWishlistProducts.where((p) => p.category.name == selectedCategoryName).toList();

    if (!_isOnline) {
      return OfflineScreen(
        onRetry: () {
          _checkInternetConnection();
        },
      );
    }

    if (_isCheckingInternet || _showShimmer || wishlistRepository.isLoading) {
      return ProductListShimmer(isLightMode: isLightMode);
    }

    if (filteredWishlistProducts.isEmpty) {
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
        ),
        body: Center(
          child: Text(
            'هنوز محصولی به لیست علاقه‌مندی‌ها اضافه نکردی.',
            style: TextStyle(color: isLightMode ? AppColors.grey600 : AppColors.grey200),
          ),
        ),
      );
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
              if (_isCategoryChanging)
                ProductGridShimmer(isLightMode: isLightMode)
              else
                ProductGrid(isLightMode: isLightMode, products: filteredWishlistProducts),
            ],
          ),
        ),
      ),
    );
  }
}
