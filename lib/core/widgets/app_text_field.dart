import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:full_plants_ecommerce_app/core/utils/persian_number.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../theme/app_colors.dart';
import '../utils/size_config.dart';
import 'gap.dart';
import 'app_alert_dialog.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
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
    this.showErrors = false,
    this.textInputAction,
  });

  final TextEditingController? controller;
  final bool? enabled;
  final String? hintText;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final bool? isDateField;
  final bool? isLightMode;
  final bool? isPassword;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? preffixIcon;
  final bool showErrors;
  final String? suffixIcon;
  final TextDirection? textDirection;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode _focusNode;

  bool _hadError = false;
  bool _isFocused = false;
  bool _obscure = false;
  bool _successPulse = false;

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

  Widget _AnimatedSvgIcon({required String asset, required Color targetColor, double? size}) {
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: targetColor),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (_, color, __) {
        return SvgPicture.asset(asset, width: size, height: size, color: color);
      },
    );
  }

  Color _computeIconColor({
    required bool hasError,
    required bool isFocused,
    required bool hasText,
    required bool isLight,
    required Color base,
    required Color error,
    required Color success,
  }) {
    if (hasError) return error;
    if (isFocused) return base;
    if (hasText) return isLight ? AppColors.grey900 : AppColors.white;
    return isLight ? AppColors.grey500 : AppColors.grey600;
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

  Future<String?> _handleDateTap() async {
    final picked = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali(1300, 1, 1),
      lastDate: Jalali(1450, 12, 29),
      locale: const Locale('fa', 'IR'),
      initialEntryMode: PersianDatePickerEntryMode.calendar,
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
      _focusNode.unfocus();
      FocusScope.of(context).unfocus();
      setState(() {});
      return value;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDate = widget.isDateField == true;
    final controller = widget.controller;
    final initText = controller?.text ?? (widget.initialValue ?? '');
    final isLight = widget.isLightMode ?? false;

    return FormField<String>(
      initialValue: initText,
      autovalidateMode: widget.showErrors ? AutovalidateMode.always : AutovalidateMode.disabled,
      validator: (val) {
        if (isDate) {
          final userV = widget.validator?.call(val);
          if (userV != null) return userV;
          return _dateValidator(val);
        }
        return widget.validator?.call(val);
      },
      builder: (field) {
        final textNow = controller?.text ?? field.value ?? '';
        final hasText = textNow.trim().isNotEmpty;
        final hasErrorNow = widget.showErrors && field.errorText != null;
        final showPulse = _successPulse;

        final targetIconColor = showPulse
            ? AppColors.success
            : _computeIconColor(
                hasError: hasErrorNow,
                isFocused: _isFocused,
                hasText: hasText,
                isLight: isLight,
                base: AppColors.primary,
                error: AppColors.error,
                success: AppColors.success,
              );

        if (!hasErrorNow && _hadError && widget.showErrors) {
          _successPulse = true;
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) setState(() => _successPulse = false);
          });
        }
        _hadError = hasErrorNow;

        final base = AppColors.primary;
        final error = AppColors.error;
        final success = AppColors.success;

        final bgColor = hasErrorNow
            ? error.withValues(alpha: 0.08)
            : _successPulse
            ? success.withValues(alpha: 0.08)
            : (_isFocused
                  ? base.withValues(alpha: 0.06)
                  : (isLight ? AppColors.grey50 : AppColors.dark2));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
                border: _isFocused
                    ? Border.all(
                        color: hasErrorNow ? error : (_successPulse ? success : base),
                        width: 1.5,
                      )
                    : null,
              ),
              child: TextFormField(
                textInputAction: widget.textInputAction,
                controller: controller,
                initialValue: controller == null ? initText : null,
                focusNode: _focusNode,
                textDirection: widget.textDirection,
                readOnly: isDate,
                obscureText: _obscure,
                enabled: widget.enabled ?? true,
                keyboardType: isDate
                    ? TextInputType.none
                    : (widget.keyboardType ?? TextInputType.text),
                inputFormatters: isDate ? const [] : (widget.inputFormatters ?? const []),
                onTap: () async {
                  if (isDate) {
                    final v = await _handleDateTap();
                    if (v != null) {
                      field.didChange(v);
                    }
                  }
                },
                onChanged: (v) {
                  field.didChange(v);
                  widget.onChanged?.call(v);
                  setState(() {});
                },
                autovalidateMode: AutovalidateMode.disabled,
                style: TextStyle(
                  color: isLight ? AppColors.grey900 : AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: SizeConfig.getProportionateFontSize(14),
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.getProportionateScreenWidth(16),
                    vertical: SizeConfig.getProportionateScreenHeight(18),
                  ),
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: hasErrorNow
                        ? error
                        : isLight
                        ? AppColors.grey500
                        : AppColors.grey600,
                    fontSize: SizeConfig.getProportionateFontSize(14),
                  ),
                  border: InputBorder.none,
                  errorText: null,
                  errorStyle: const TextStyle(fontSize: 0, height: 0),
                  prefixIcon: widget.preffixIcon != null
                      ? SizedBox(
                          width: SizeConfig.getProportionateScreenWidth(60),
                          child: Center(
                            child: _AnimatedSvgIcon(
                              asset: widget.preffixIcon!,
                              size: SizeConfig.getProportionateScreenWidth(20),
                              targetColor: targetIconColor,
                            ),
                          ),
                        )
                      : null,
                  suffixIcon: widget.isPassword == true
                      ? IconButton(
                          onPressed: () => setState(() => _obscure = !_obscure),
                          icon: _AnimatedSvgIcon(
                            asset: _obscure
                                ? 'assets/images/icons/Hide_bold.svg'
                                : 'assets/images/icons/Show_bold.svg',
                            size: SizeConfig.getProportionateScreenWidth(20),
                            targetColor: targetIconColor,
                          ),
                        )
                      : (widget.suffixIcon != null
                            ? SizedBox(
                                width: SizeConfig.getProportionateScreenWidth(40),
                                child: Center(
                                  child: _AnimatedSvgIcon(
                                    asset: widget.suffixIcon!,
                                    size: SizeConfig.getProportionateScreenWidth(20),
                                    targetColor: targetIconColor,
                                  ),
                                ),
                              )
                            : null),
                ),
              ),
            ),
            Gap(SizeConfig.getProportionateScreenHeight(10)),
            if (hasErrorNow) AppAlertDialog(text: field.errorText!, isError: true),
          ],
        );
      },
    );
  }
}
