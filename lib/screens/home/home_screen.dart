import 'package:flutter/material.dart';
import 'package:full_plants_ecommerce_app/components/custom_category_bar.dart';
import 'package:full_plants_ecommerce_app/models/auth/auth_models.dart';
import '../../components/widgets/custom_app_bar.dart';
import '../../components/custom_search_bar.dart';
import '../../components/custom_title_bar.dart';
import '../../components/special_offer_card.dart';

import '../../utils/size.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.tokens});

  static String routeName = './home';

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
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;

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
                CustomTitleBarOfProducts(title: 'پیشنهاد ویژه'),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
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
