import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/colors.dart';
import '../utils/size.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.isLightMode,
    this.textInputType,
    required this.preffixIcon,
    required this.hintText,
    this.suffixIcon,
    required this.obscureText,
  });

  final String hintText;
  final bool isLightMode;
  final bool obscureText;
  final String preffixIcon;
  final String? suffixIcon;
  final TextInputType? textInputType;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.obscureText,
      focusNode: _focusNode,
      keyboardType: widget.textInputType,
      style: TextStyle(
        color: widget.isLightMode ? AppColors.grey900 : AppColors.white,
        fontWeight: FontWeight.w600,
        fontSize: SizeConfig.getProportionateScreenWidth(14),
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getProportionateScreenWidth(16),
          vertical: SizeConfig.getProportionateScreenHeight(18),
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: widget.isLightMode ? AppColors.grey500 : AppColors.grey600,
          fontSize: SizeConfig.getProportionateScreenWidth(14),
          fontFamily: 'IranYekan',
        ),
        prefixIcon: SizedBox(
          width: SizeConfig.getProportionateScreenWidth(60),
          child: Center(
            child: SvgPicture.asset(
              widget.preffixIcon,
              width: SizeConfig.getProportionateScreenWidth(20),
              height: SizeConfig.getProportionateScreenWidth(20),
              color: widget.isLightMode
                  ? _isFocused
                        ? AppColors.primary
                        : AppColors.grey500
                  : _isFocused
                  ? AppColors.white
                  : AppColors.grey600,
            ),
          ),
        ),
        suffixIcon: widget.suffixIcon != null
            ? SizedBox(
                width: SizeConfig.getProportionateScreenWidth(60),
                child: Center(
                  child: SvgPicture.asset(
                    widget.suffixIcon!,
                    width: SizeConfig.getProportionateScreenWidth(20),
                    height: SizeConfig.getProportionateScreenWidth(20),
                    color: _isFocused ? AppColors.primary : AppColors.grey500,
                  ),
                ),
              )
            : null,
        filled: true,
        fillColor: widget.isLightMode
            ? _isFocused
                  ? AppColors.primary.withValues(alpha: 0.08)
                  : AppColors.grey50
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
    );
  }
}
