import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/shimmer/home_screen_shimmer.dart';
import '../../../../core/widgets/shimmer/product_grid_shimmer.dart';
import '../../../product/data/repositories/product_repository.dart';
import '../widgets/custom_category_bar.dart';
import '../../../product/presentation/widgets/product_grid.dart';
import '../widgets/home_app_bar.dart';
import '../../../../core/widgets/app_search_bar.dart';
import '../../../../core/widgets/app_title_bar.dart';
import '../../../product/presentation/widgets/special_offer_card.dart';
import '../../../auth/data/models/auth_tokens_model.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../offline/presentation/screens/offline_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.tokens});

  final AuthTokens? tokens;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FocusNode _focusNode = FocusNode();

  bool _isFocused = false;

  bool _isCheckingInternet = true;
  bool _isOnline = true;
  bool _showShimmer = true;
  bool _isCategoryChanging = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeApp();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
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

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final shopRepository = context.read<ShopRepository>();

      shopRepository.loadCategories().then((_) {
        shopRepository.loadAllProducts().then((_) {
          shopRepository.loadProducts();
        });
      });
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

    if (_showShimmer) {
      return HomeScreenShimmer(isLightMode: isLightMode);
    }

    if (!_isOnline) {
      return OfflineScreen(
        onRetry: () {
          _checkInternetConnection();
        },
      );
    }

    if (_isCheckingInternet) {
      return HomeScreenShimmer(isLightMode: isLightMode);
    }

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
                CustomAppBar(isLightMode: isLightMode),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
                AppSearchBar(
                  focusNode: _focusNode,
                  isLightMode: isLightMode,
                  isFocused: _isFocused,
                ),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
                if (shopRepository.error != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      shopRepository.error!,
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                AppTitleBar(title: 'پیشنهاد ویژه'),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
                SpecialOfferCard(isLightMode: isLightMode),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
                AppTitleBar(title: 'محبوب ترین'),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
                CustomCategoryBar(indexCategory: -1, onCategoryChanged: _onCategoryChanged),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
                if (_isCategoryChanging)
                  ProductGridShimmer(isLightMode: isLightMode)
                else
                  ProductGrid(shopRepository: shopRepository, isLightMode: isLightMode),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
