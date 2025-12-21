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

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _countryCtrl = TextEditingController();
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
  late String _iLastName;
  late String _iGender;
  late String _iPhone;
  bool _loading = false;
  bool _prefilled = false;
  bool _serverIsError = true;
  bool _showErrors = false;

  File? _avatarFile;
  String? _serverMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_prefilled) return;

    final me = context.read<AuthRepository>().me;
    if (me == null) return;

    _iLastName = me.lastName;
    _iFirstName = me.firstName;
    _iDob = me.birthDate ?? '';
    _iEmail = me.email;
    _iPhone = me.phoneNumber;
    _iGender = me.gender;

    _lastNameCtrl.text = me.lastName;
    _firstNameCtrl.text = me.firstName;
    _dobCtrl.text = (me.birthDate ?? '').replaceAll('-', '/');
    _emailCtrl.text = me.email;
    _phoneCtrl.text = me.phoneNumber;

    _genderCtrl.text = me.gender.isEmpty ? 'Male' : me.gender;

    _prefilled = true;
  }

  @override
  void dispose() {
    _lastNameCtrl.dispose();
    _firstNameCtrl.dispose();
    _dobCtrl.dispose();
    _emailCtrl.dispose();
    _countryCtrl.dispose();
    _phoneCtrl.dispose();
    _genderCtrl.dispose();
    super.dispose();
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

  Map<String, dynamic> _buildPatchBody() {
    final patch = <String, dynamic>{};

    final lastNow = _lastNameCtrl.text.trim();
    final firstNow = _firstNameCtrl.text.trim();

    final dobUi = _dobCtrl.text.trim();
    final dobServer = _toEnglishDigits(dobUi).replaceAll('/', '-');

    final emailNow = _emailCtrl.text.trim();
    final phoneNow = _toEnglishDigits(_phoneCtrl.text.trim());
    final genderNow = _genderCtrl.text.trim();

    final lastChanged = lastNow != _iLastName.trim();
    final firstChanged = firstNow != _iFirstName.trim();

    if (lastChanged || firstChanged) {
      final desiredFirst = firstNow.isNotEmpty
          ? firstNow
          : (lastNow.isNotEmpty ? lastNow.split(' ').first : _iFirstName);

      final desiredLast = lastChanged
          ? _guessLastName(fullName: lastNow, firstName: desiredFirst)
          : _guessLastName(fullName: _iLastName, firstName: _iFirstName);

      patch['first_name'] = desiredFirst;
      patch['last_name'] = desiredLast;
    }

    if (dobServer != (_iDob.isEmpty ? '' : _iDob)) {
      if (dobServer.isNotEmpty) patch['date_of_birth'] = dobServer;
    }

    if (emailNow != _iEmail) {
      patch['email'] = emailNow;
    }

    if (phoneNow != _toEnglishDigits(_iPhone)) {
      patch['phone_number'] = phoneNow;
    }

    if (genderNow.isNotEmpty && genderNow != _iGender) {
      patch['gender'] = genderNow;
    }

    return patch;
  }

  String _guessLastName({required String fullName, required String firstName}) {
    final f = firstName.trim();
    final full = fullName.trim();
    if (full.isEmpty) return '';
    final parts = full.split(' ').where((e) => e.trim().isNotEmpty).toList();
    if (parts.length <= 1) return '';
    if (f.isNotEmpty && full.startsWith(f)) {
      return full.substring(f.length).trim();
    }
    return parts.sublist(1).join(' ');
  }

  Future<void> _pickAvatar() async {
    final status = await Permission.photos.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      _showMsg('اجازه دسترسی به تصاویر داده نشد', isError: true);
      return;
    }

    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() => _avatarFile = File(picked.path));
    _showMsg('عکس انتخاب شد (برای ذخیره Update بزن)', isError: false);
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

    if (patch.isEmpty && _avatarFile == null) {
      _showMsg('هیچ تغییری ثبت نشده است', isError: true);
      return;
    }

    setState(() => _loading = true);

    final res = await ProfileApi().edit(fields: patch, avatarFile: _avatarFile);

    if (!mounted) return;
    setState(() => _loading = false);

    if (res.success && res.data != null) {
      await context.read<AuthRepository>().setMe(res.data!);

      _prefilled = false;
      didChangeDependencies();

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
            fontWeight: FontWeight.w800,
            color: isLightMode ? AppColors.grey900 : AppColors.white,
            fontSize: SizeConfig.getProportionateFontSize(21),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.getProportionateScreenWidth(20)),
            child: IconButton(
              onPressed: _pickAvatar,
              icon: SvgPicture.asset(
                'assets/images/icons/Image.svg',
                width: SizeConfig.getProportionateScreenWidth(24),
                height: SizeConfig.getProportionateScreenWidth(24),
                color: isLightMode ? AppColors.grey900 : AppColors.white,
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
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Gap(SizeConfig.getProportionateScreenHeight(14)),
                      if (_serverMessage != null) ...[
                        AppAlertDialog(text: _serverMessage!, isError: _serverIsError),
                        Gap(SizeConfig.getProportionateScreenHeight(12)),
                      ],

                      AppTextField(
                        isLightMode: isLightMode,
                        controller: _firstNameCtrl,
                        hintText: 'نام',
                        suffixIcon: 'assets/images/icons/Profile.svg',
                        showErrors: _showErrors,
                        validator: Validators.requiredBlankValidator,
                        textDirection: TextDirection.rtl,
                      ),
                      Gap(SizeConfig.getProportionateScreenHeight(15)),

                      AppTextField(
                        isLightMode: isLightMode,
                        controller: _lastNameCtrl,
                        hintText: 'نام خانوادگی',
                        suffixIcon: 'assets/images/icons/Profile.svg',
                        showErrors: _showErrors,
                        validator: Validators.requiredBlankValidator,
                      ),
                      Gap(SizeConfig.getProportionateScreenHeight(15)),

                      AppTextField(
                        isLightMode: isLightMode,
                        controller: _dobCtrl,
                        hintText: 'تاریخ تولد',
                        isDateField: true,
                        suffixIcon: 'assets/images/icons/Calendar_curve.svg',
                        showErrors: _showErrors,
                        validator: _dobValidator,
                      ),
                      Gap(SizeConfig.getProportionateScreenHeight(15)),

                      AppTextField(
                        isLightMode: isLightMode,
                        controller: _emailCtrl,
                        hintText: 'ایمیل',
                        suffixIcon: 'assets/images/icons/Message_curve.svg',
                        showErrors: _showErrors,
                        validator: Validators.requiredEmailValidator,
                        textDirection: TextDirection.ltr,
                        keyboardType: TextInputType.emailAddress,
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
                      ),

                      Gap(SizeConfig.getProportionateScreenHeight(15)),
                      AppDropDown(
                        controller: _genderCtrl,
                        hint: 'جنسیت',
                        items: const ['زن', 'مرد'],
                        showErrors: _showErrors,
                        validator: (v) {
                          if ((v ?? '').trim().isEmpty) return 'لطفاً انتخاب کنید';
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
              child: _loading
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
