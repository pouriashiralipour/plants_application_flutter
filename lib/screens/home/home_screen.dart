import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:full_plants_ecommerce_app/utils/persian_number.dart';
import 'package:full_plants_ecommerce_app/utils/price_comma_seperator.dart';

import '../../components/custom_app_bar.dart';
import '../../components/custom_search_bar.dart';
import '../../components/custom_title_bar.dart';
import '../../theme/colors.dart';
import '../../utils/size.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static String routeName = './home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FocusNode _focusNode = FocusNode();

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
              SizedBox(
                width: double.infinity,
                height: SizeConfig.getProportionateScreenHeight(362),
                child: Container(
                  width: SizeConfig.getProportionateScreenWidth(240),
                  height: SizeConfig.getProportionateScreenHeight(362),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(6, (index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                right: SizeConfig.getProportionateScreenWidth(16),
                              ),
                              width: SizeConfig.getProportionateScreenWidth(240),
                              height: SizeConfig.getProportionateScreenHeight(240),
                              decoration: BoxDecoration(
                                color: AppColors.bgSilver1,
                                borderRadius: BorderRadius.circular(36),
                              ),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'assets/images/Plants2.png',
                                      width: SizeConfig.getProportionateScreenWidth(240),
                                      height: SizeConfig.getProportionateScreenWidth(240),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Positioned(
                                    top: SizeConfig.getProportionateScreenHeight(16),
                                    right: SizeConfig.getProportionateScreenWidth(16),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {},
                                      child: SvgPicture.asset(
                                        'assets/images/icons/Heart_outline.svg',
                                        color: AppColors.primary,
                                        width: SizeConfig.getProportionateScreenWidth(24),
                                        height: SizeConfig.getProportionateScreenWidth(24),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                right: SizeConfig.getProportionateScreenWidth(16),
                              ),
                              child: Text(
                                'سانسوریا',
                                style: TextStyle(
                                  color: AppColors.grey900,
                                  fontSize: SizeConfig.getProportionateScreenWidth(24),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                right: SizeConfig.getProportionateScreenWidth(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/icons/Star.svg',
                                    color: AppColors.primary,
                                    width: SizeConfig.getProportionateScreenWidth(20),
                                    height: SizeConfig.getProportionateScreenWidth(20),
                                  ),
                                  SizedBox(width: SizeConfig.getProportionateScreenWidth(10)),
                                  Text(
                                    '4.8'.farsiNumber,
                                    style: TextStyle(
                                      color: AppColors.grey700,
                                      fontSize: SizeConfig.getProportionateScreenWidth(16),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: SizeConfig.getProportionateScreenWidth(10)),
                                  Text(
                                    '|',
                                    style: TextStyle(
                                      fontFamily: 'IranYekan',
                                      color: AppColors.grey700,
                                      fontWeight: FontWeight.w700,
                                      fontSize: SizeConfig.getProportionateScreenWidth(16),
                                    ),
                                  ),
                                  SizedBox(width: SizeConfig.getProportionateScreenWidth(10)),
                                  Container(
                                    width: SizeConfig.getProportionateScreenWidth(69),
                                    height: SizeConfig.getProportionateScreenHeight(24),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: BoxBorder.all(
                                        color: AppColors.primary,
                                        width: 1,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Text(
                                      '${4268.toString().priceFormatter} فروش'.farsiNumber,
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: SizeConfig.getProportionateScreenWidth(10),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                right: SizeConfig.getProportionateScreenWidth(16),
                              ),
                              child: Text(
                                '${1233000.toString().priceFormatter} تومان'.farsiNumber,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: SizeConfig.getProportionateScreenWidth(18),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
