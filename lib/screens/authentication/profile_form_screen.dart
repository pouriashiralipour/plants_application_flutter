import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../api/profile_api.dart';
import '../../auth/auth_repository.dart';
import '../../components/adaptive_gap.dart';
import '../../components/custom_progress_bar.dart';
import '../../components/widgets/custom_alert.dart';
import '../../components/widgets/custom_dialog.dart';
import '../../components/widgets/custom_drop_down.dart';
import '../../components/widgets/custom_text_field.dart';
import '../../components/widgets/cutsom_button.dart';
import '../../models/auth/auth_models.dart';
import '../../models/auth/profile_models.dart';
import '../../theme/colors.dart';
import '../../utils/size.dart';
import '../../utils/validators.dart';
import '../root/root_screen.dart';
import 'components/auth_scaffold.dart';

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({
    super.key,
    required this.token,
    required this.purpose,
    required this.target,
  });

  final String purpose;
  final String target;
  final AuthTokens token;

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
  final ImagePicker _picker = ImagePicker();

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
    var status = await Permission.photos.request();

    if (status.isDenied || status.isPermanentlyDenied) {
      return _showServerError("اجازه دسترسی به تصاویر داده نشد");
    }

    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showServerError("خطا در انتخاب تصویر: $e");
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

  void _submit() async {
    setState(() {
      _showErrors = true;
      _serverErrorMessage = null;
    });

    if (!_formKey.currentState!.validate()) return;

    final firstName = _firstNameCtrl.text.trim();
    final lastName = _lastNameCtrl.text.trim();
    final dob = _toEnglishDigits(_dobCtrl.text.trim());
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

    final token = context.read<AuthRepository>().tokens!;
    final response = await ProfileApi().complete(
      model,
      accessToken: token.access,
      avatarFile: _imageFile,
      avatarFieldName: 'profile_pic',
    );

    if (!mounted) return;

    if (response.success) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 1));
      setState(() => _isLoading = false);
      await customSuccessShowDialog(context);
    } else {
      _showServerError(response.error ?? 'خطا');
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
            fontFamily: 'Peyda',
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
                  color: AppColors.primary,
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
              AdaptiveGap(SizeConfig.getProportionateScreenHeight(15)),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CustomAlert(text: _serverErrorMessage!, isError: true),
              ),
            ],
            AdaptiveGap(SizeConfig.getProportionateScreenHeight(15)),
            CustomTextField(
              isPassword: false,
              isLightMode: isLightMode,
              showErrors: _showErrors,
              validator: Validators.requiredBlankValidator,
              hintText: 'نام',
              suffixIcon: 'assets/images/icons/Profile.svg',
              controller: _firstNameCtrl,
            ),
            AdaptiveGap(SizeConfig.getProportionateScreenHeight(15)),
            CustomTextField(
              isPassword: false,
              isLightMode: isLightMode,
              hintText: 'نام خانوادگی',
              suffixIcon: 'assets/images/icons/Profile.svg',
              controller: _lastNameCtrl,
              showErrors: _showErrors,
              validator: Validators.requiredBlankValidator,
            ),
            AdaptiveGap(SizeConfig.getProportionateScreenHeight(15)),
            CustomTextField(
              isPassword: false,
              isLightMode: isLightMode,
              hintText: 'تاریخ تولد',
              suffixIcon: 'assets/images/icons/Calendar_curve.svg',
              isDateField: true,
              controller: _dobCtrl,
              validator: _dobValidator,
              showErrors: _showErrors,
            ),
            AdaptiveGap(SizeConfig.getProportionateScreenHeight(15)),
            !widget.target.contains("@")
                ? CustomTextField(
                    isPassword: false,
                    isLightMode: isLightMode,
                    hintText: 'ایمیل',
                    controller: _emailCtrl,
                    suffixIcon: 'assets/images/icons/Message_curve.svg',
                    validator: Validators.requiredEmailValidator,
                    showErrors: _showErrors,
                    textDirection: TextDirection.ltr,
                  )
                : CustomTextField(
                    isPassword: false,
                    isLightMode: isLightMode,
                    hintText: 'شماره موبایل',
                    controller: _phoneCtrl,
                    suffixIcon: 'assets/images/icons/Call_curve.svg',
                    validator: Validators.requiredMobileValidator,
                    showErrors: _showErrors,
                  ),
            AdaptiveGap(SizeConfig.getProportionateScreenHeight(15)),
            CustomTextField(
              isPassword: true,
              suffixIcon: 'assets/images/icons/Hide_bold.svg',
              isLightMode: isLightMode,
              hintText: 'رمزعبور',
              controller: _passwordCtrl,
              validator: Validators.requiredPasswordValidator,
              showErrors: _showErrors,
              textDirection: TextDirection.ltr,
            ),
            AdaptiveGap(SizeConfig.getProportionateScreenHeight(15)),
            FancyDropdownFormField(
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
          ? CusstomProgressBar()
          : CustomButton(
              onTap: _submit,
              text: 'ادامه',
              color: AppColors.disabledButton,
              width: SizeConfig.getProportionateScreenWidth(98),
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
      return CustomSuccessDialog(
        text: 'حساب کاربری شما فعال شد.\nتا لحظاتی دیگر به صفحه خانه هدایت می شوید',
      );
    },
  );
}
