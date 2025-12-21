import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_alert_dialog.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_drop_down.dart';
import '../../../../core/widgets/app_progress_indicator.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/gap.dart';
import '../../../auth/data/datasources/profile_remote_data_source.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import '../../data/models/profile_models.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _dobCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _genderCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  late String _iDob;
  late String _iEmail;
  late String _iFirstName;
  late String _iGenderEn;
  late String _iLastName;
  late String _iPhone;
  bool _isLoading = false;
  bool _prefilled = false;
  bool _serverIsError = true;
  bool _showErrors = false;

  File? _imageFile;
  String? _serverMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_prefilled) return;

    final me = context.read<AuthRepository>().me;
    if (me == null) return;

    _applyProfileToForm(me);
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _dobCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _genderCtrl.dispose();
    super.dispose();
  }

  void _applyProfileToForm(UserProfile me) {
    _iFirstName = me.firstName;
    _iLastName = me.lastName;
    _iDob = me.birthDate ?? '';
    _iEmail = me.email;
    _iPhone = me.phoneNumber;
    _iGenderEn = me.gender;

    _firstNameCtrl.text = me.firstName;
    _lastNameCtrl.text = me.lastName;
    _dobCtrl.text = (me.birthDate ?? '').replaceAll('-', '/');
    _emailCtrl.text = me.email;
    _phoneCtrl.text = me.phoneNumber;
    _genderCtrl.text = _mapGenderEnToFa(me.gender);

    _prefilled = true;
  }

  Map<String, dynamic> _buildPatchBody() {
    final patch = <String, dynamic>{};

    final firstNow = _firstNameCtrl.text.trim();
    final lastNow = _lastNameCtrl.text.trim();

    final dobNow = _toEnglishDigits(_dobCtrl.text.trim()).replaceAll('/', '-');
    final emailNow = _emailCtrl.text.trim();
    final phoneNow = _toEnglishDigits(_phoneCtrl.text.trim());
    final genderEnNow = _mapGenderFaToEn(_genderCtrl.text.trim());

    if (firstNow.isNotEmpty && firstNow != _iFirstName) {
      patch['first_name'] = firstNow;
    }

    if (lastNow.isNotEmpty && lastNow != _iLastName) {
      patch['last_name'] = lastNow;
    }

    if (dobNow != (_iDob.isEmpty ? '' : _iDob)) {
      if (dobNow.isNotEmpty) patch['date_of_birth'] = dobNow;
    }

    if (emailNow.isNotEmpty && emailNow != _iEmail) {
      patch['email'] = emailNow;
    }

    if (phoneNow.isNotEmpty && phoneNow != _toEnglishDigits(_iPhone)) {
      patch['phone_number'] = phoneNow;
    }

    if (genderEnNow.isNotEmpty && genderEnNow != _iGenderEn) {
      patch['gender'] = genderEnNow;
    }

    return patch;
  }

  String? _dobValidator(String? v) {
    final s = _toEnglishDigits((v ?? '').trim());
    if (s.isEmpty) return 'تاریخ تولد را وارد کنید';
    final re = RegExp(r'^\d{4}/\d{2}/\d{2}$');
    if (!re.hasMatch(s)) return 'قالب تاریخ: YYYY/MM/DD';
    return null;
  }

  String _mapGenderEnToFa(String g) {
    final x = g.trim().toLowerCase();
    if (x == 'female') return 'زن';
    if (x == 'male') return 'مرد';
    if (g == 'زن' || g == 'مرد') return g;
    return '';
  }

  String _mapGenderFaToEn(String? g) {
    if (g == 'زن') return 'Female';
    if (g == 'مرد') return 'Male';
    return '';
  }

  Future<void> _pickImage() async {
    final status = await Permission.photos.request();

    if (status.isDenied || status.isPermanentlyDenied) {
      return _showMsg('اجازه دسترسی به تصاویر داده نشد', isError: true);
    }

    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() => _imageFile = File(pickedFile.path));
        _showMsg('عکس انتخاب شد (برای ذخیره تایید بزن)', isError: false);
      }
    } catch (e) {
      _showMsg('خطا در انتخاب تصویر: $e', isError: true);
    }
  }

  void _showMsg(String text, {required bool isError}) {
    setState(() {
      _serverMessage = text;
      _serverIsError = isError;
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      setState(() => _serverMessage = null);
    });
  }

  Future<void> _submit() async {
    setState(() {
      _showErrors = true;
      _serverMessage = null;
    });

    if (!_formKey.currentState!.validate()) return;

    final patch = _buildPatchBody();
    if (patch.isEmpty && _imageFile == null) {
      return _showMsg('هیچ تغییری ثبت نشده است', isError: true);
    }

    final authRepo = context.read<AuthRepository>();

    setState(() => _isLoading = true);

    final res = await ProfileApi().edit(fields: patch, avatarFile: _imageFile);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (res.success && res.data != null) {
      await authRepo.setMe(res.data!);

      _prefilled = false;
      _applyProfileToForm(res.data!);

      _imageFile = null;

      _showMsg('اطلاعات بروزرسانی شد', isError: false);
    } else {
      _showMsg(res.error ?? 'خطا', isError: true);
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

    return Scaffold(
      backgroundColor: isLightMode ? AppColors.white : AppColors.dark1,
      appBar: AppBar(
        backgroundColor: isLightMode ? AppColors.white : AppColors.dark1,
        elevation: 0,
        title: Text(
          'تغییر پروفایل',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isLightMode ? AppColors.grey900 : AppColors.white,
            fontSize: SizeConfig.getProportionateScreenWidth(21),
            fontFamily: 'Peyda',
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.getProportionateScreenWidth(20)),
            child: IconButton(
              onPressed: _pickImage,
              icon: SvgPicture.asset(
                'assets/images/icons/Image.svg',
                width: SizeConfig.getProportionateScreenWidth(24),
                height: SizeConfig.getProportionateScreenWidth(24),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProportionateScreenWidth(24),
                  vertical: SizeConfig.getProportionateScreenHeight(24),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Gap(SizeConfig.getProportionateScreenHeight(24)),
                      if (_serverMessage != null) ...[
                        AppAlertDialog(text: _serverMessage!, isError: _serverIsError),
                        Gap(SizeConfig.getProportionateScreenHeight(12)),
                      ],
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

                      AppTextField(
                        isPassword: false,
                        isLightMode: isLightMode,
                        hintText: 'ایمیل',
                        controller: _emailCtrl,
                        suffixIcon: 'assets/images/icons/Message_curve.svg',
                        validator: Validators.requiredEmailValidator,
                        showErrors: _showErrors,
                        textDirection: TextDirection.ltr,
                      ),

                      Gap(SizeConfig.getProportionateScreenHeight(15)),

                      AppTextField(
                        isPassword: false,
                        isLightMode: isLightMode,
                        hintText: 'شماره موبایل',
                        controller: _phoneCtrl,
                        suffixIcon: 'assets/images/icons/Call_curve.svg',
                        validator: Validators.requiredMobileValidator,
                        showErrors: _showErrors,
                        textDirection: TextDirection.ltr,
                      ),

                      Gap(SizeConfig.getProportionateScreenHeight(15)),

                      AppDropDown(
                        controller: _genderCtrl,
                        hint: 'جنسیت',
                        items: const ['زن', 'مرد'],
                        showErrors: _showErrors,
                        validator: (v) {
                          if ((v ?? '').trim().isEmpty) return 'لطفاً جنسیت را انتخاب کنید';
                          return null;
                        },
                        onChanged: (v) => _genderCtrl.text = v,
                      ),

                      Gap(SizeConfig.getProportionateScreenHeight(24)),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(
                SizeConfig.getProportionateScreenWidth(24),
                0,
                SizeConfig.getProportionateScreenWidth(24),
                MediaQuery.of(context).viewInsets.bottom > 0
                    ? SizeConfig.getProportionateScreenHeight(12)
                    : SizeConfig.getProportionateScreenHeight(18),
              ),
              child: _isLoading
                  ? const AppProgressBarIndicator()
                  : AppButton(
                      onTap: _submit,
                      text: 'تایید',
                      color: AppColors.primary,
                      width: SizeConfig.screenWidth,
                      fontSize: SizeConfig.getProportionateFontSize(16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
