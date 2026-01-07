import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/shimmer/home_screen_shimmer.dart';
import '../../../../core/widgets/shimmer/product/product_grid_shimmer.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../product/presentation/controllers/product_controller.dart';
import '../../../product/presentation/screens/search_screen.dart';
import '../../../product/presentation/widgets/product_grid_entity.dart';
import '../widgets/category_bar_entity.dart';
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

  bool _isCategoryChanging = false;
  bool _isCheckingInternet = true;
  bool _isFocused = false;
  bool _isOnline = true;
  bool _showShimmer = true;

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = context.read<ProductController>();

      await controller.loadCategories();
      await controller.loadProducts();
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
    final controller = context.watch<ProductController>();

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
                SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
                CustomAppBar(isLightMode: isLightMode, loginBuilder: (_) => const LoginScreen()),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
                AppSearchBar(
                  filterOnTap: () {},
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SearchScreen()),
                    );
                  },
                  focusNode: _focusNode,
                  isLightMode: isLightMode,
                  isFocused: _isFocused,
                  readOnly: true,
                ),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
                AppTitleBar(title: 'پیشنهاد ویژه'),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
                SpecialOfferCard(isLightMode: isLightMode),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
                AppTitleBar(title: 'محبوب ترین'),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
                CategoryBarEntity(indexCategory: -1, onCategoryChanged: _onCategoryChanged),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(20)),
                if (_isCategoryChanging)
                  ProductGridShimmer(isLightMode: isLightMode)
                else
                  ProductGridEntity(isLightMode: isLightMode, products: controller.products),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
