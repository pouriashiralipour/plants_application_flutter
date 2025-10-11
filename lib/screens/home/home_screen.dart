import 'package:flutter/material.dart';
import 'package:full_plants_ecommerce_app/components/custom_progress_bar.dart';
import 'package:provider/provider.dart';

import '../../auth/shop_repository.dart';
import '../../components/custom_category_bar.dart';
import '../../components/widgets/custom_app_bar.dart';
import '../../components/custom_search_bar.dart';
import '../../components/custom_title_bar.dart';
import '../../components/special_offer_card.dart';
import '../../models/auth/auth_models.dart';
import '../../utils/size.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.tokens});

  final AuthTokens? tokens;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FocusNode _focusNode = FocusNode();

  int _indexCategory = 0;
  bool _isFocused = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShopRepository>().loadProducts();
      context.read<ShopRepository>().loadCategories();
    });
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    final shopRepository = context.watch<ShopRepository>();

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
                CustmoSearchBar(
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
                CustomTitleBarOfProducts(title: 'پیشنهاد ویژه'),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
                if (shopRepository.isLoading) const CusstomProgressBar(),
                SpecialOfferCard(isLightMode: isLightMode),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
                CustomTitleBarOfProducts(title: 'محبوب ترین'),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
                CustomCategoryBar(indexCategory: _indexCategory),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
