import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:full_plants_ecommerce_app/utils/persian_number.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../theme/colors.dart';
import '../../utils/size.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.isLightMode = false,
    this.preffixIcon,
    this.hintText,
    this.controller,
    this.suffixIcon,
    this.isDateField = false,
    this.isPassword = false,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
    this.enabled,
    this.textDirection = TextDirection.rtl,
    this.onChanged,
    this.initialValue,
  });

  final TextEditingController? controller;
  final String? hintText;
  final bool? isLightMode;
  final bool? isDateField;
  final bool? isPassword;
  final String? preffixIcon;
  final String? suffixIcon;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final TextDirection? textDirection;
  final ValueChanged<String>? onChanged;
  final String? initialValue;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final FocusNode _focusNode;

  bool _hasText = false;
  bool _isFocused = false;
  bool _obscure = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword!;
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  String? _dateValidator(String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'تاریخ را انتخاب کنید';
    }
    final v = val.englishNumber.trim();

    final re = RegExp(r'^(13|14)\d{2}\/(0[1-9]|1[0-2])\/(0[1-9]|[12]\d|3[01])$');
    if (!re.hasMatch(v)) {
      return 'فرمت تاریخ صحیح نیست (مثال: ۱۴۰۳/۰۷/۱۲)';
    }
    return null;
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

  Future<void> _handleDateTap() async {
    final picked = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali(1300, 1, 1),
      lastDate: Jalali(1450, 12, 29),
      locale: const Locale('fa', 'IR'),
      initialEntryMode: PersianDatePickerEntryMode.calendar,
      // helpText: 'انتخاب تاریخ تولد',
      fieldLabelText: 'تاریخ تولد',
      fieldHintText: '1378/07/12'.farsiNumber,
      errorFormatText: 'فرمت تاریخ نادرست است',
      errorInvalidText: 'تاریخ نامعتبر است',
    );

    if (picked != null) {
      final f = picked.formatter;
      final value = '${f.yyyy}/${f.mm}/${f.dd}'.farsiNumber;
      widget.controller?.text = value;
      widget.onChanged?.call(value);
      setState(() {
        _hasText = value.isNotEmpty;
      });

      _focusNode.unfocus();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDate = widget.isDateField == true;
    return TextFormField(
      initialValue: widget.initialValue,
      controller: widget.controller,
      obscureText: _obscure,
      focusNode: _focusNode,
      enabled: widget.enabled ?? true,
      readOnly: isDate,
      keyboardType: isDate ? TextInputType.none : (widget.keyboardType ?? TextInputType.text),
      inputFormatters: isDate ? const [] : (widget.inputFormatters ?? const []),
      textDirection: widget.textDirection,
      onChanged: (value) {
        setState(() {
          _hasText = value.isNotEmpty;
        });
        widget.onChanged?.call(value);
      },
      onTap: () async {
        if (isDate) {
          await _handleDateTap();
        }
      },
      validator: isDate
          ? (val) {
              final v = widget.validator?.call(val);
              if (v != null) return v;
              return _dateValidator(val);
            }
          : widget.validator,
      style: TextStyle(
        color: widget.isLightMode! ? AppColors.grey900 : AppColors.white,
        fontWeight: FontWeight.w600,
        fontFamily: 'Peyda',
        fontSize: SizeConfig.getProportionateFontSize(14),
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getProportionateScreenWidth(16),
          vertical: SizeConfig.getProportionateScreenHeight(18),
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: widget.isLightMode! ? AppColors.grey500 : AppColors.grey600,
          fontSize: SizeConfig.getProportionateFontSize(14),
          fontFamily: 'Peyda',
        ),
        prefixIcon: widget.preffixIcon != null
            ? SizedBox(
                width: SizeConfig.getProportionateScreenWidth(60),
                child: Center(
                  child: SvgPicture.asset(
                    widget.preffixIcon!,
                    width: SizeConfig.getProportionateScreenWidth(20),
                    height: SizeConfig.getProportionateScreenWidth(20),
                    color: _getIconColor(_isFocused, _hasText, widget.isLightMode!),
                  ),
                ),
              )
            : null,
        suffixIcon: widget.isPassword!
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
                icon: SvgPicture.asset(
                  _obscure
                      ? 'assets/images/icons/Hide_bold.svg'
                      : 'assets/images/icons/Show_bold.svg',
                  width: SizeConfig.getProportionateScreenWidth(20),
                  height: SizeConfig.getProportionateScreenWidth(20),
                  color: _getIconColor(_isFocused, _hasText, widget.isLightMode!),
                ),
              )
            : (widget.suffixIcon != null
                  ? SizedBox(
                      width: SizeConfig.getProportionateScreenWidth(40),
                      child: Center(
                        child: SvgPicture.asset(
                          widget.suffixIcon!,
                          width: SizeConfig.getProportionateScreenWidth(20),
                          height: SizeConfig.getProportionateScreenWidth(20),
                          color: _getIconColor(_isFocused, _hasText, widget.isLightMode!),
                        ),
                      ),
                    )
                  : null),
        filled: true,
        fillColor: widget.isLightMode!
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
