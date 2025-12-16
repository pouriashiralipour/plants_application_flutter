import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../utils/size_config.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    required FocusNode focusNode,
    required this.isLightMode,
    required bool isFocused,
    required this.onTap,
    required this.filterOnTap,
    this.controller,
    this.onSubmitted,
    this.onChanged,
    required this.readOnly,
  }) : _focusNode = focusNode,
       _isFocused = isFocused;

  final TextEditingController? controller;
  final bool isLightMode;
  final ValueChanged<String>? onChanged;
  final VoidCallback filterOnTap;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback onTap;
  final bool readOnly;

  final FocusNode _focusNode;
  final bool _isFocused;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.getProportionateScreenWidth(24)),
      child: TextFormField(
        onTap: onTap,
        focusNode: _focusNode,
        controller: controller,
        readOnly: readOnly,
        textInputAction: TextInputAction.search,
        onFieldSubmitted: onSubmitted,
        onChanged: onChanged,
        style: TextStyle(
          color: isLightMode ? AppColors.grey900 : AppColors.white,
          fontWeight: FontWeight.w600,
          fontSize: SizeConfig.getProportionateFontSize(14),
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.getProportionateScreenWidth(16),
            vertical: SizeConfig.getProportionateScreenHeight(16),
          ),
          hintText: "جستجو",
          hintStyle: TextStyle(
            color: isLightMode ? AppColors.grey400 : AppColors.grey600,
            fontSize: SizeConfig.getProportionateFontSize(14),
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
              child: IconButton(
                icon: SvgPicture.asset(
                  _isFocused
                      ? 'assets/images/icons/Filter_fill.svg'
                      : 'assets/images/icons/Filter.svg',
                  width: SizeConfig.getProportionateScreenWidth(20),
                  height: SizeConfig.getProportionateScreenWidth(20),
                  color: AppColors.primary,
                ),
                onPressed: filterOnTap,
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
    );
  }
}
