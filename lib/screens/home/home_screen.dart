import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/custom_app_bar.dart';
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
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
            CustomAppBar(isLightMode: isLightMode),
            SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
            Container(
              margin: EdgeInsets.symmetric(horizontal: SizeConfig.getProportionateScreenWidth(24)),
              child: TextFormField(
                focusNode: _focusNode,
                style: TextStyle(
                  color: isLightMode ? AppColors.grey900 : AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: SizeConfig.getProportionateScreenWidth(14),
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.getProportionateScreenWidth(16),
                    vertical: SizeConfig.getProportionateScreenHeight(16),
                  ),
                  hintText: "جستجو",
                  hintStyle: TextStyle(
                    color: isLightMode ? AppColors.grey400 : AppColors.grey600,
                    fontSize: SizeConfig.getProportionateScreenWidth(14),
                    fontFamily: 'IranYekan',
                  ),
                  prefixIcon: SizedBox(
                    width: SizeConfig.getProportionateScreenWidth(60),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/icons/Search.svg',
                        width: SizeConfig.getProportionateScreenWidth(20),
                        height: SizeConfig.getProportionateScreenWidth(20),
                        color: isLightMode
                            ? _isFocused
                                  ? AppColors.primary
                                  : AppColors.grey400
                            : _isFocused
                            ? AppColors.white
                            : AppColors.grey600,
                      ),
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: SizeConfig.getProportionateScreenWidth(60),
                    child: Center(
                      child: SvgPicture.asset(
                        _isFocused
                            ? 'assets/images/icons/Filter_fill.svg'
                            : 'assets/images/icons/Filter.svg',
                        width: SizeConfig.getProportionateScreenWidth(20),
                        height: SizeConfig.getProportionateScreenWidth(20),
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  filled: true,
                  fillColor: isLightMode
                      ? _isFocused
                            ? AppColors.primary.withValues(alpha: 0.08)
                            : AppColors.grey100
                      : _isFocused
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : AppColors.dark2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
