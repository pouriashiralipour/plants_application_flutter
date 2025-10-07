import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:full_plants_ecommerce_app/models/otp_models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import '../../api/api_services.dart';
import '../../components/adaptive_gap.dart';
import '../../components/custom_progress_bar.dart';
import '../../components/widgets/custom_alert.dart';
import '../../components/widgets/custom_dialog.dart';
import '../../components/widgets/custom_drop_down.dart';
import '../../components/widgets/custom_text_field.dart';
import '../../components/widgets/cutsom_button.dart';
import '../../models/profile_models.dart';
import '../../theme/colors.dart';
import '../../utils/size.dart';
import '../../utils/validators.dart';
import '../root/root_screen.dart';
import 'components/auth_scaffold.dart';

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({super.key, this.token, this.purpose = 'register', required this.target});

  static String routeName = './profile_form';

  final String? purpose;
  final String target;
  final AuthTokens? token;

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  late ProfileCompleteModels profileCompleteModels;
  late ProfileServices profileServices;

  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;
  bool _showErrors = false;

  File? _imageFile;
  String? _selectedGenderFa;
  String? _serverErrorMessage;

  @override
  void dispose() {
    _birthDateController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    profileServices = ProfileServices();
    profileCompleteModels = ProfileCompleteModels(
      gender: '',
      firstName: '',
      lastName: '',
      dateOfBirthJalali: '',
      password: '',
    );
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

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 1));
      final svc = ProfileServices();
      final result = await svc.completeProfile(
        ProfileCompleteModels(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          dateOfBirthJalali: _birthDateController.text.trim(),
          password: _passwordController.text,
          email: _emailController.text.isEmpty ? null : _emailController.text.trim(),
          phoneNumber: _phoneNumberController.text.isEmpty
              ? null
              : _phoneNumberController.text.trim(),
          gender: _mapGenderFaToEn(_selectedGenderFa),
        ),
        accessToken: widget.token!.access,
        avatarFile: _imageFile,
        avatarFieldName: 'profile_pic',
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result.ok) {
        await customSuccessShowDialog(context);
      } else {
        _showServerError(result.error ?? 'خطا');
      }
    }
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
              onChanged: (value) {
                setState(() {
                  profileCompleteModels.firstName;
                });
              },
              validator: Validators.requiredBlankValidator,
              hintText: 'نام',
              suffixIcon: 'assets/images/icons/Profile.svg',
              controller: _firstNameController,
            ),
            AdaptiveGap(SizeConfig.getProportionateScreenHeight(15)),
            CustomTextField(
              isPassword: false,
              isLightMode: isLightMode,
              hintText: 'نام خانوادگی',
              suffixIcon: 'assets/images/icons/Profile.svg',
              controller: _lastNameController,
              showErrors: _showErrors,
              onChanged: (value) {
                setState(() {
                  profileCompleteModels.lastName;
                });
              },
              validator: Validators.requiredBlankValidator,
            ),
            AdaptiveGap(SizeConfig.getProportionateScreenHeight(15)),
            CustomTextField(
              isPassword: false,
              isLightMode: isLightMode,
              hintText: 'تاریخ تولد',
              suffixIcon: 'assets/images/icons/Calendar_curve.svg',
              isDateField: true,
              controller: _birthDateController,
              validator: (value) {
                return null;
              },
              showErrors: _showErrors,
              onChanged: (value) {
                setState(() {
                  profileCompleteModels.dateOfBirthJalali;
                });
              },
            ),
            AdaptiveGap(SizeConfig.getProportionateScreenHeight(15)),
            !widget.target.contains("@")
                ? CustomTextField(
                    isPassword: false,
                    isLightMode: isLightMode,
                    hintText: 'ایمیل',
                    controller: _emailController,
                    suffixIcon: 'assets/images/icons/Message_curve.svg',
                    onChanged: (value) {
                      setState(() {
                        profileCompleteModels.email;
                      });
                    },
                    validator: Validators.requiredEmailValidator,
                    showErrors: _showErrors,
                    textDirection: TextDirection.ltr,
                  )
                : CustomTextField(
                    isPassword: false,
                    isLightMode: isLightMode,
                    hintText: 'شماره موبایل',
                    controller: _phoneNumberController,
                    suffixIcon: 'assets/images/icons/Call_curve.svg',
                    onChanged: (value) {
                      setState(() {
                        profileCompleteModels.phoneNumber;
                      });
                    },
                    validator: Validators.requiredMobileValidator,
                    showErrors: _showErrors,
                  ),
            AdaptiveGap(SizeConfig.getProportionateScreenHeight(15)),
            CustomTextField(
              isPassword: true,
              suffixIcon: 'assets/images/icons/Hide_bold.svg',
              isLightMode: isLightMode,
              hintText: 'رمزعبور',
              controller: _passwordController,
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
