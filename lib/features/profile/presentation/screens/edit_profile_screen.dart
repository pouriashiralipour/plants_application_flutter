import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../../../core/config/app_constants.dart';
import '../../../../core/services/app_image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/persian_digits_input_formatter.dart';
import '../../../../core/utils/persian_number.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_alert_dialog.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_drop_down.dart';
import '../../../../core/widgets/app_progress_indicator.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/gap.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import '../../../auth/data/datasources/profile_remote_data_source.dart';
import '../../data/models/profile_models.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _genderCtrl = TextEditingController();

  bool _loading = false;
  bool _showErrors = false;
  bool _prefilled = false;

  // آواتار جدید (بعد از crop)
  File? _avatarFile;

  // پیام سرور
  String? _serverMessage;
  bool _serverIsError = true;

  // snapshot برای PATCH
  late String _iFirstName;
  late String _iLastName;
  late String _iDob;
  late String _iEmail;
  late String _iPhone;
  late String _iGenderEn;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_prefilled) return;

    final me = context.read<AuthRepository>().me;
    if (me == null) return;

    _applyProfileToForm(me);
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

    // نمایش تاریخ و موبایل با اعداد فارسی
    _dobCtrl.text = (me.birthDate ?? '').replaceAll('-', '/').farsiNumber;
    _phoneCtrl.text = (me.phoneNumber).farsiNumber;

    _emailCtrl.text = me.email;
    _genderCtrl.text = _mapGenderEnToFa(me.gender);

    _prefilled = true;
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

  String _mapGenderFaToEn(String? g) {
    if (g == 'زن') return 'Female';
    if (g == 'مرد') return 'Male';
    return '';
  }

  String _mapGenderEnToFa(String g) {
    final x = g.trim().toLowerCase();
    if (x == 'female') return 'زن';
    if (x == 'male') return 'مرد';
    if (g == 'زن' || g == 'مرد') return g;
    return '';
  }

  String? _dobValidator(String? v) {
    final s = _toEnglishDigits((v ?? '').trim());
    if (s.isEmpty) return 'تاریخ تولد را وارد کنید';
    final re = RegExp(r'^\d{4}/\d{2}/\d{2}$');
    if (!re.hasMatch(s)) return 'قالب تاریخ: YYYY/MM/DD';
    return null;
  }

  Future<void> _pickAvatar() async {
    final res = await AppImagePicker.pickAndCrop(
      context: context,
      source: ImageSource.gallery,
      cropStyle: CropStyle.circle,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );

    if (!mounted) return;

    switch (res.status) {
      case AppImagePickStatus.picked:
        setState(() => _avatarFile = res.file);
        _showMsg('عکس انتخاب شد (برای ذخیره تایید بزن)', isError: false);
        break;
      case AppImagePickStatus.permissionDenied:
        _showMsg(res.message ?? 'اجازه دسترسی به تصاویر داده نشد', isError: true);
        break;
      case AppImagePickStatus.error:
        _showMsg(res.message ?? 'خطا', isError: true);
        break;
      case AppImagePickStatus.cancelled:
        // هیچ کاری نکن
        break;
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

  Map<String, dynamic> _buildPatchBody() {
    final patch = <String, dynamic>{};

    final firstNow = _firstNameCtrl.text.trim();
    final lastNow = _lastNameCtrl.text.trim();

    final dobUi = _dobCtrl.text.trim(); // ممکنه فارسی باشد
    final dobServer = _toEnglishDigits(dobUi).replaceAll('/', '-');

    final emailNow = _emailCtrl.text.trim();
    final phoneNow = _toEnglishDigits(_phoneCtrl.text.trim());
    final genderEnNow = _mapGenderFaToEn(_genderCtrl.text.trim());

    if (firstNow.isNotEmpty && firstNow != _iFirstName) patch['first_name'] = firstNow;
    if (lastNow.isNotEmpty && lastNow != _iLastName) patch['last_name'] = lastNow;

    if (dobServer != (_iDob.isEmpty ? '' : _iDob)) {
      if (dobServer.isNotEmpty) patch['date_of_birth'] = dobServer;
    }

    if (emailNow.isNotEmpty && emailNow != _iEmail) patch['email'] = emailNow;
    if (phoneNow.isNotEmpty && phoneNow != _toEnglishDigits(_iPhone))
      patch['phone_number'] = phoneNow;

    if (genderEnNow.isNotEmpty && genderEnNow != _iGenderEn) patch['gender'] = genderEnNow;

    return patch;
  }

  Future<void> _submit() async {
    setState(() {
      _showErrors = true;
      _serverMessage = null;
    });

    if (!_formKey.currentState!.validate()) return;

    final patch = _buildPatchBody();
    if (patch.isEmpty && _avatarFile == null) {
      return _showMsg('هیچ تغییری ثبت نشده است', isError: true);
    }

    final authRepo = context.read<AuthRepository>();

    setState(() => _loading = true);
    final res = await ProfileApi().edit(fields: patch, avatarFile: _avatarFile);

    if (!mounted) return;
    setState(() => _loading = false);

    if (res.success && res.data != null) {
      await authRepo.setMe(res.data!);

      // فرم و snapshot را با داده جدید sync کن (بدون صدا زدن didChangeDependencies دستی)
      _prefilled = false;
      _applyProfileToForm(res.data!);

      _avatarFile = null;
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
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    final me = context.watch<AuthRepository>().me;
    final avatarUrl = buildAvatarUrl(me?.profilePic, UrlInfo.baseUrl);

    final ImageProvider? avatarProvider = _avatarFile != null
        ? FileImage(_avatarFile!)
        : (avatarUrl != null ? NetworkImage(avatarUrl) : null);

    return Scaffold(
      backgroundColor: isLightMode ? AppColors.white : AppColors.dark1,
      appBar: AppBar(
        backgroundColor: isLightMode ? AppColors.white : AppColors.dark1,
        elevation: 0,
        title: Text(
          'ویرایش پروفایل',
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

                      // ✅ آواتار مثل ProfileScreen
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: SizeConfig.getProportionateScreenWidth(50),
                            backgroundColor: isLightMode ? AppColors.grey200 : AppColors.dark3,
                            backgroundImage: avatarProvider,
                            child: avatarProvider == null
                                ? Icon(
                                    Icons.person,
                                    color: isLightMode ? AppColors.grey600 : AppColors.grey100,
                                    size: SizeConfig.getProportionateScreenWidth(40),
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickAvatar,
                              child: Container(
                                width: SizeConfig.getProportionateScreenWidth(34),
                                height: SizeConfig.getProportionateScreenWidth(34),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.12),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: SizeConfig.getProportionateScreenWidth(18),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Gap(SizeConfig.getProportionateScreenHeight(16)),

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

                      // ✅ موبایل: ورودی و نمایش فارسی
                      AppTextField(
                        isLightMode: isLightMode,
                        controller: _phoneCtrl,
                        hintText: 'شماره موبایل',
                        suffixIcon: 'assets/images/icons/Call_curve.svg',
                        showErrors: _showErrors,
                        validator: Validators.requiredMobileValidator,
                        textDirection: TextDirection.ltr,
                        keyboardType: TextInputType.phone,
                        inputFormatters: const [PersianDigitsTextInputFormatter()],
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

String? buildAvatarUrl(String? raw, String baseUrl) {
  if (raw == null) return null;
  final avatar = raw.trim();
  if (avatar.isEmpty) return null;
  if (avatar.startsWith('http')) return avatar;
  if (avatar.startsWith('/')) return '$baseUrl${avatar.substring(1)}';
  return '$baseUrl$avatar';
}
