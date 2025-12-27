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
import '../../../auth/data/datasources/auth_remote_data_source.dart';
import '../../../auth/data/datasources/profile_remote_data_source.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/user_profile.dart';

enum _ChangeIdMode { email, phone }

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _dobCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _emailOtpCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _genderCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _newEmailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  late String _iDob;
  late String _iEmail;
  late String _iFirstName;
  late String _iGenderEn;
  late String _iLastName;
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

    final me = context.read<AuthController>().user;
    if (me != null) {
      _applyProfileToForm(me);
    }

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
    _newEmailCtrl.dispose();
    _emailOtpCtrl.dispose();

    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    _showErrors = false;
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

    _dobCtrl.text = (me.birthDate ?? '').replaceAll('-', '/').farsiNumber;
    _phoneCtrl.text = (me.phoneNumber).farsiNumber;

    _emailCtrl.text = me.email;
    _genderCtrl.text = _mapGenderEnToFa(me.gender);

    _prefilled = true;
  }

  Map<String, dynamic> _buildPatchBody() {
    final patch = <String, dynamic>{};

    final firstNow = _firstNameCtrl.text.trim();
    final lastNow = _lastNameCtrl.text.trim();

    final dobUi = _dobCtrl.text.trim();
    final dobServer = _toEnglishDigits(dobUi).replaceAll('/', '-');

    final genderEnNow = _mapGenderFaToEn(_genderCtrl.text.trim());

    if (firstNow.isNotEmpty && firstNow != _iFirstName) patch['first_name'] = firstNow;
    if (lastNow.isNotEmpty && lastNow != _iLastName) patch['last_name'] = lastNow;

    if (dobServer != (_iDob.isEmpty ? '' : _iDob)) {
      if (dobServer.isNotEmpty) patch['date_of_birth'] = dobServer;
    }

    if (genderEnNow.isNotEmpty && genderEnNow != _iGenderEn) patch['gender'] = genderEnNow;

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

  Future<void> _openChangeIdentifierModal({required _ChangeIdMode mode}) async {
    final auth = context.read<AuthController>();
    final me = auth.user;
    if (me == null) return;

    final currentValue = mode == _ChangeIdMode.email ? me.email : me.phoneNumber;

    final changed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ChangeIdentifierOtpSheet(mode: mode, currentValue: currentValue),
    );

    if (changed != true || !mounted) return;

    await auth.reloadProfile();
    final updated = auth.user;
    if (updated == null) return;

    _prefilled = false;
    _applyProfileToForm(updated);

    _showMsg(
      mode == _ChangeIdMode.email ? 'ایمیل بروزرسانی شد' : 'شماره موبایل بروزرسانی شد',
      isError: false,
    );
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

    final auth = context.read<AuthController>();

    setState(() => _loading = true);

    await WidgetsBinding.instance.endOfFrame;

    const minLoading = Duration(seconds: 1);
    final sw = Stopwatch()..start();

    final res = await ProfileApi().edit(fields: patch, avatarFile: _avatarFile);

    sw.stop();
    final remaining = minLoading - sw.elapsed;
    if (remaining > Duration.zero) {
      await Future.delayed(remaining);
    }

    if (!mounted) return;
    setState(() => _loading = false);

    if (res.success && res.data != null) {
      await auth.reloadProfile();
      final me = auth.user;

      if (me != null) {
        _prefilled = false;
        _applyProfileToForm(me);
      }
      _prefilled = false;

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

    final auth = context.watch<AuthController>();
    final me = auth.user;
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

                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: .circle,
                              border: .all(width: 2, color: AppColors.primary),
                            ),
                            child: CircleAvatar(
                              radius: SizeConfig.getProportionateScreenWidth(60),
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
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickAvatar,
                              child: SizedBox(
                                width: SizeConfig.getProportionateScreenWidth(30),
                                height: SizeConfig.getProportionateScreenWidth(30),
                                child: SvgPicture.asset(
                                  'assets/images/icons/Edit_squre.svg',
                                  colorFilter: .mode(AppColors.primary, .srcIn),
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
                        preffixIcon: 'assets/images/icons/Message_curve.svg',
                        showErrors: _showErrors,
                        validator: Validators.requiredEmailValidator,
                        textDirection: TextDirection.ltr,
                        keyboardType: TextInputType.emailAddress,
                        enabled: false,
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextButton(
                          onPressed: () => _openChangeIdentifierModal(mode: _ChangeIdMode.email),
                          child: Text(
                            'تغییر ایمیل با OTP',
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),

                      Gap(SizeConfig.getProportionateScreenHeight(15)),

                      AppTextField(
                        isLightMode: isLightMode,
                        controller: _phoneCtrl,
                        hintText: 'شماره موبایل',
                        preffixIcon: 'assets/images/icons/Call_curve.svg',
                        showErrors: _showErrors,
                        validator: Validators.requiredMobileValidator,
                        textDirection: TextDirection.ltr,
                        keyboardType: TextInputType.phone,
                        inputFormatters: const [PersianDigitsTextInputFormatter()],
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextButton(
                          onPressed: () => _openChangeIdentifierModal(mode: _ChangeIdMode.phone),
                          child: Text(
                            'تغییر شماره موبایل با OTP',
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                          ),
                        ),
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

class _ChangeIdentifierOtpSheet extends StatefulWidget {
  const _ChangeIdentifierOtpSheet({required this.mode, required this.currentValue});

  final String currentValue;
  final _ChangeIdMode mode;

  @override
  State<_ChangeIdentifierOtpSheet> createState() => _ChangeIdentifierOtpSheetState();
}

class _ChangeIdentifierOtpSheetState extends State<_ChangeIdentifierOtpSheet> {
  final _formKey = GlobalKey<FormState>();
  final _otpCtrl = TextEditingController();
  final _targetCtrl = TextEditingController();

  bool _isError = true;
  bool _otpSent = false;
  bool _reqLoading = false;
  bool _showErrors = false;
  bool _verifyLoading = false;

  String? _msg;

  @override
  void dispose() {
    _targetCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  String _normalizeForCompare(String raw) {
    final v = raw.trim();

    if (widget.mode == _ChangeIdMode.email) {
      return v.toLowerCase();
    }

    var x = v.englishNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (x.startsWith('+98')) x = '0${x.substring(3)}';
    if (x.startsWith('98')) x = '0${x.substring(2)}';

    return x;
  }

  String _normalizeTarget(String raw) {
    final v = raw.trim();
    if (widget.mode == _ChangeIdMode.phone) {
      return v.englishNumber.replaceAll(RegExp(r'\s+'), '');
    }
    return v;
  }

  Future<void> _requestOtp() async {
    setState(() {
      _showErrors = true;
      _msg = null;
    });

    if (!_formKey.currentState!.validate()) return;

    final target = _normalizeTarget(_targetCtrl.text);
    final targetCmp = _normalizeForCompare(target);
    final currentCmp = _normalizeForCompare(widget.currentValue);

    if (targetCmp == currentCmp) {
      _setMsg(
        widget.mode == _ChangeIdMode.email
            ? 'این ایمیل همان ایمیل فعلی است؛ لطفاً ایمیل جدید وارد کنید.'
            : 'این شماره همان شماره فعلی است؛ لطفاً شماره جدید وارد کنید.',
        isError: true,
      );
      return;
    }

    setState(() => _reqLoading = true);

    final res = await AuthApi().requestChangeIdentifierOtp(target: target);

    if (!mounted) return;
    setState(() => _reqLoading = false);

    if (res.success) {
      setState(() => _otpSent = true);
      _setMsg('کد تایید ارسال شد', isError: false);
    } else {
      final raw = (res.error ?? '').trim();

      final isDuplicate =
          raw.toLowerCase().contains('already') ||
          raw.toLowerCase().contains('exists') ||
          raw.contains('تکراری') ||
          raw.contains('قبلا') ||
          raw.contains('استفاده');

      if (isDuplicate) {
        _setMsg(
          widget.mode == _ChangeIdMode.email
              ? 'این ایمیل قبلاً ثبت شده است. لطفاً یک ایمیل دیگر وارد کنید.'
              : 'این شماره قبلاً ثبت شده است. لطفاً یک شماره دیگر وارد کنید.',
          isError: true,
        );
      } else {
        _setMsg(raw.isEmpty ? 'ارسال کد ناموفق بود' : raw, isError: true);
      }
    }
  }

  void _setMsg(String text, {required bool isError}) {
    setState(() {
      _msg = text;
      _isError = isError;
    });
  }

  String? _targetValidator(String? v) {
    final raw = (v ?? '').trim();
    if (widget.mode == _ChangeIdMode.email) {
      return Validators.requiredEmailValidator(raw);
    }
    return Validators.requiredMobileValidator(raw);
  }

  Future<void> _verifyOtp() async {
    final code = _otpCtrl.text.trim().englishNumber;
    if (code.length != 6) {
      _setMsg('کد ۶ رقمی را کامل وارد کنید', isError: true);
      return;
    }

    setState(() {
      _verifyLoading = true;
      _msg = null;
    });

    final res = await AuthApi().verifyChangeIdentifierOtp(code: code);

    if (!mounted) return;
    setState(() => _verifyLoading = false);

    if (res.success && res.data != null) {
      Navigator.pop<bool>(context, true);
    } else {
      _setMsg(res.error ?? 'کد نامعتبر است', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    final title = widget.mode == _ChangeIdMode.email ? 'تغییر ایمیل' : 'تغییر شماره موبایل';
    final hint = widget.mode == _ChangeIdMode.email ? 'ایمیل جدید' : 'شماره جدید';

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: isLightMode ? AppColors.white : AppColors.dark1,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 28,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getProportionateScreenWidth(20),
          vertical: SizeConfig.getProportionateScreenHeight(14),
        ),
        child: SafeArea(
          top: false,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.grey300.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                Gap(SizeConfig.getProportionateScreenHeight(12)),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: SizeConfig.getProportionateFontSize(18),
                          fontWeight: FontWeight.w800,
                          color: isLightMode ? AppColors.grey900 : AppColors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close_rounded,
                        color: isLightMode ? AppColors.grey900 : AppColors.white,
                      ),
                    ),
                  ],
                ),

                Gap(SizeConfig.getProportionateScreenHeight(12)),

                if (_msg != null) ...[
                  AppAlertDialog(text: _msg!, isError: _isError),
                  Gap(SizeConfig.getProportionateScreenHeight(12)),
                ],

                AppTextField(
                  isLightMode: isLightMode,
                  controller: _targetCtrl,
                  hintText: hint,
                  showErrors: _showErrors,
                  validator: _targetValidator,
                  textDirection: TextDirection.ltr,
                  keyboardType: widget.mode == _ChangeIdMode.email
                      ? TextInputType.emailAddress
                      : TextInputType.phone,
                  inputFormatters: widget.mode == _ChangeIdMode.phone
                      ? const [PersianDigitsTextInputFormatter()]
                      : null,
                ),

                Gap(SizeConfig.getProportionateScreenHeight(12)),

                _reqLoading
                    ? const AppProgressBarIndicator()
                    : AppButton(
                        onTap: _requestOtp,
                        text: _otpSent ? 'ارسال مجدد کد' : 'ارسال کد تایید',
                        color: AppColors.primary,
                        width: SizeConfig.screenWidth,
                        fontSize: SizeConfig.getProportionateFontSize(14),
                      ),

                if (_otpSent) ...[
                  Gap(SizeConfig.getProportionateScreenHeight(14)),
                  AppTextField(
                    isLightMode: isLightMode,
                    controller: _otpCtrl,
                    hintText: 'کد ۶ رقمی',
                    textDirection: TextDirection.ltr,
                    keyboardType: TextInputType.number,
                    inputFormatters: const [PersianDigitsTextInputFormatter()],
                  ),
                  Gap(SizeConfig.getProportionateScreenHeight(12)),
                  _verifyLoading
                      ? const AppProgressBarIndicator()
                      : AppButton(
                          onTap: _verifyOtp,
                          text: 'تایید و اعمال تغییر',
                          color: AppColors.success,
                          width: SizeConfig.screenWidth,
                          fontSize: SizeConfig.getProportionateFontSize(14),
                        ),
                ],

                Gap(SizeConfig.getProportionateScreenHeight(18)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
