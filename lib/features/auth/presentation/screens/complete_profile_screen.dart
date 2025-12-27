import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../../../core/config/root_screen.dart';
import '../../../../core/services/app_image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/persian_digits_input_formatter.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/gap.dart';
import '../../../../core/widgets/app_alert_dialog.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/app_drop_down.dart';
import '../../../../core/widgets/app_progress_indicator.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../profile/data/models/profile_form_models.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../widgets/auth_scaffold.dart';

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({super.key, required this.purpose, required this.target});

  final String purpose;
  final String target;

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  final _dobCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _lastNameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  bool _isLoading = false;
  bool _showErrors = false;

  File? _imageFile;
  String? _selectedGenderFa;
  String? _serverErrorMessage;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _dobCtrl.dispose();
    _passwordCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.target.contains('@')) {
      _emailCtrl.text = widget.target;
    } else {
      _phoneCtrl.text = widget.target;
    }
  }

  String? _dobValidator(String? v) {
    final s = _toEnglishDigits((v ?? '').trim());
    if (s.isEmpty) return 'تاریخ تولد را وارد کنید';
    final re = RegExp(r'^\d{4}/\d{2}/\d{2}$');
    if (!re.hasMatch(s)) return 'قالب تاریخ: YYYY/MM/DD';
    return null;
  }

  String _mapGenderFaToEn(String? g) {
    if (g == 'زن') return 'Female';
    if (g == 'مرد') return 'Male';
    return '';
  }

  Future<void> _pickImage() async {
    final res = await AppImagePicker.pickAndCrop(
      context: context,
      source: ImageSource.gallery,
      cropStyle: CropStyle.circle,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );

    if (!mounted) return;

    switch (res.status) {
      case AppImagePickStatus.picked:
        setState(() => _imageFile = res.file);
        break;
      case AppImagePickStatus.permissionDenied:
        _showServerError(res.message ?? "اجازه دسترسی به تصاویر داده نشد");
        break;
      case AppImagePickStatus.error:
        _showServerError(res.message ?? "خطا");
        break;
      case AppImagePickStatus.cancelled:
        break;
    }
  }

  void _showServerError(String message) {
    setState(() {
      _serverErrorMessage = message;
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _serverErrorMessage = null;
        });
      }
    });
  }

  Future<void> _submit() async {
    setState(() {
      _showErrors = true;
      _serverErrorMessage = null;
    });

    if (!_formKey.currentState!.validate()) return;

    final firstName = _firstNameCtrl.text.trim();
    final lastName = _lastNameCtrl.text.trim();
    final dob = _toEnglishDigits(_dobCtrl.text.trim()).replaceAll('/', '-');
    final password = _passwordCtrl.text;
    final email = _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim();
    final phone = _toEnglishDigits(_phoneCtrl.text.trim().isEmpty ? '' : _phoneCtrl.text.trim());

    final model = ProfileCompleteModels(
      firstName: firstName,
      lastName: lastName,
      dateOfBirthJalali: dob,
      password: password,
      gender: _mapGenderFaToEn(_selectedGenderFa),
      email: email,
      phoneNumber: phone.isEmpty ? null : phone,
    );

    setState(() => _isLoading = true);

    final res = await ProfileApi().complete(model, avatarFile: _imageFile);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (res.success) {
      final auth = context.read<AuthController>();
      await auth.reloadProfile();

      await Future.delayed(const Duration(seconds: 1));
      setState(() => _isLoading = false);
      await customSuccessShowDialog(context);
    } else {
      _showServerError(res.error ?? 'خطا');
    }
  }

  String _toEnglishDigits(String s) {
    const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    const ar = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    for (var i = 0; i < 10; i++) {
      s = s.replaceAll(fa[i], i.toString()).replaceAll(ar[i], i.toString());
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return AuthScaffold(
      appBar: AppBar(
        title: Text(
          'تکمیل کردن پروفایل',
          style: TextStyle(
            color: isLightMode ? AppColors.grey900 : AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.getProportionateScreenWidth(21),
          ),
        ),
      ),
      header: Stack(
        children: [
          Container(
            width: SizeConfig.getProportionateScreenWidth(120),
            height: SizeConfig.getProportionateScreenWidth(120),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.contain,
                image: _imageFile != null
                    ? FileImage(_imageFile!)
                    : AssetImage(
                        isLightMode
                            ? 'assets/images/profile.png'
                            : 'assets/images/profile_dark.png',
                      ),
              ),
            ),
          ),
          Positioned(
            top: 105,
            left: 105,
            child: GestureDetector(
              onTap: _pickImage,
              child: SizedBox(
                width: SizeConfig.getProportionateScreenWidth(35),
                height: SizeConfig.getProportionateScreenWidth(35),
                child: SvgPicture.asset(
                  'assets/images/icons/Edit_squre.svg',
                  colorFilter: .mode(AppColors.primary, .srcIn),
                ),
              ),
            ),
          ),
        ],
      ),
      form: Form(
        key: _formKey,
        child: Column(
          children: [
            if (_serverErrorMessage != null) ...[
              Gap(SizeConfig.getProportionateScreenHeight(15)),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: AppAlertDialog(text: _serverErrorMessage!, isError: true),
              ),
            ],
            Gap(SizeConfig.getProportionateScreenHeight(15)),
            AppTextField(
              isPassword: false,
              isLightMode: isLightMode,
              showErrors: _showErrors,
              validator: Validators.requiredBlankValidator,
              hintText: 'نام',
              suffixIcon: 'assets/images/icons/Profile.svg',
              controller: _firstNameCtrl,
            ),
            Gap(SizeConfig.getProportionateScreenHeight(15)),
            AppTextField(
              isPassword: false,
              isLightMode: isLightMode,
              hintText: 'نام خانوادگی',
              suffixIcon: 'assets/images/icons/Profile.svg',
              controller: _lastNameCtrl,
              showErrors: _showErrors,
              validator: Validators.requiredBlankValidator,
            ),
            Gap(SizeConfig.getProportionateScreenHeight(15)),
            AppTextField(
              isPassword: false,
              isLightMode: isLightMode,
              hintText: 'تاریخ تولد',
              suffixIcon: 'assets/images/icons/Calendar_curve.svg',
              isDateField: true,
              controller: _dobCtrl,
              validator: _dobValidator,
              showErrors: _showErrors,
            ),
            Gap(SizeConfig.getProportionateScreenHeight(15)),
            !widget.target.contains("@")
                ? AppTextField(
                    isPassword: false,
                    isLightMode: isLightMode,
                    hintText: 'ایمیل',
                    controller: _emailCtrl,
                    suffixIcon: 'assets/images/icons/Message_curve.svg',
                    validator: Validators.requiredEmailValidator,
                    showErrors: _showErrors,
                    textDirection: TextDirection.ltr,
                  )
                : AppTextField(
                    isPassword: false,
                    isLightMode: isLightMode,
                    hintText: 'شماره موبایل',
                    controller: _phoneCtrl,
                    suffixIcon: 'assets/images/icons/Call_curve.svg',
                    validator: Validators.requiredMobileValidator,
                    showErrors: _showErrors,
                    inputFormatters: const [PersianDigitsTextInputFormatter()],
                  ),
            Gap(SizeConfig.getProportionateScreenHeight(15)),
            AppTextField(
              isPassword: true,
              suffixIcon: 'assets/images/icons/Hide_bold.svg',
              isLightMode: isLightMode,
              hintText: 'رمزعبور',
              controller: _passwordCtrl,
              validator: Validators.requiredPasswordValidator,
              showErrors: _showErrors,
              textDirection: TextDirection.ltr,
            ),
            Gap(SizeConfig.getProportionateScreenHeight(15)),
            AppDropDown(
              hint: 'جنسیت',
              items: const ['زن', 'مرد'],
              showErrors: _showErrors,
              validator: (v) {
                if ((v ?? '').trim().isEmpty) return 'لطفاً جنسیت را انتخاب کنید';
                return null;
              },
              onChanged: (v) {
                setState(() => _selectedGenderFa = v);
              },
            ),
          ],
        ),
      ),
      footer: _isLoading
          ? AppProgressBarIndicator()
          : AppButton(
              onTap: _submit,
              text: 'ادامه',
              color: AppColors.disabledButton,
              width: SizeConfig.getProportionateScreenWidth(98),
              fontSize: SizeConfig.getProportionateFontSize(16),
            ),
    );
  }
}

Future<dynamic> customSuccessShowDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.grey900.withValues(alpha: 0.8),
    builder: (BuildContext context) {
      Future.delayed(const Duration(seconds: 5), () {
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RootScreen()));
      });
      return AppDialog(text: 'حساب کاربری شما فعال شد.\nتا لحظاتی دیگر به صفحه خانه هدایت می شوید');
    },
  );
}
