import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/colors.dart';
import '../utils/size.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool isLightMode;
  final String preffixIcon;
  final String? suffixIcon;
  final TextInputType? textInputType;
  final bool isPassword;
  const CustomTextField({
    super.key,
    required this.isLightMode,
    this.textInputType,
    required this.preffixIcon,
    required this.hintText,
    this.suffixIcon,
    this.isPassword = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  late bool _obscureText;
  bool _hasText = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  Color _getIconColor(bool isFocused, bool hasText, bool isLightMode) {
    if (isFocused) {
      return isLightMode ? AppColors.primary : AppColors.white;
    } else {
      if (hasText) {
        return isLightMode ? AppColors.grey900 : AppColors.white;
      } else {
        return isLightMode ? AppColors.grey500 : AppColors.grey600;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _obscureText,
      focusNode: _focusNode,
      keyboardType: widget.textInputType,
      onChanged: (value) {
        setState(() {
          _hasText = value.isNotEmpty;
        });
      },
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
              color: _getIconColor(_isFocused, _hasText, widget.isLightMode),
            ),
          ),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: SvgPicture.asset(
                  _obscureText
                      ? 'assets/images/icons/Hide_bold.svg'
                      : 'assets/images/icons/Show_bold.svg',
                  width: SizeConfig.getProportionateScreenWidth(20),
                  height: SizeConfig.getProportionateScreenWidth(20),
                  color: _getIconColor(_isFocused, _hasText, widget.isLightMode),
                ),
              )
            : (widget.suffixIcon != null
                  ? SvgPicture.asset(
                      widget.suffixIcon!,
                      width: SizeConfig.getProportionateScreenWidth(20),
                      height: SizeConfig.getProportionateScreenWidth(20),
                      color: _getIconColor(_isFocused, _hasText, widget.isLightMode),
                    )
                  : null),
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
