import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:full_plants_ecommerce_app/components/custom_text_field.dart';
import 'package:full_plants_ecommerce_app/components/cutsom_button.dart';
import 'package:full_plants_ecommerce_app/screens/authentication/components/auth_svg_asset_widget.dart';
import 'package:full_plants_ecommerce_app/screens/authentication/components/remember_me.dart';


import '../../theme/colors.dart';
import '../../utils/size.dart';
import 'login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  static String routeName = './change_password';
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ساخت رمزعبور جدید',
          style: TextStyle(
            color: isLightMode ? AppColors.grey900 : AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: SizeConfig.getProportionateScreenWidth(21),
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProportionateScreenWidth(24),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AuthSvgAssetWidget(
                      svg: isLightMode
                          ? 'assets/images/new_pass_light.svg'
                          : 'assets/images/new_pass_dark.svg',
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.1),
                    Text(
                      'رمزعبور جدید خود را وارد کنید',
                      style: TextStyle(
                        color: isLightMode ? AppColors.grey900 : AppColors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: SizeConfig.getProportionateScreenWidth(16),
                      ),
                    ),
                    SizedBox(height: SizeConfig.getProportionateScreenHeight(24)),
                    Column(
                      children: List.generate(
                        2,
                        (index) => Padding(
                          padding: EdgeInsets.only(
                            bottom: SizeConfig.getProportionateScreenHeight(24),
                          ),
                          child: CustomTextField(
                            isPassword: true,
                            suffixIcon: 'assets/images/icons/Hide_bold.svg',
                            isLightMode: isLightMode,
                            preffixIcon: 'assets/images/icons/Lock_bold.svg',
                            hintText: index == 0 ? 'رمزعبور' : 'تکرار رمزعبور',
                          ),
                        ),
                      ),
                    ),
                    RememberMeWidget(),
                    SizedBox(height: SizeConfig.screenHeight * 0.1),
                    CustomButton(
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          barrierColor: Colors.black.withValues(alpha: 0.85),
                          builder: (BuildContext context) {
                            Future.delayed(const Duration(minutes: 4), () {
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                            });
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(44),
                              ),
                              child: SizedBox(
                                width: SizeConfig.getProportionateScreenWidth(340),
                                height: SizeConfig.getProportionateScreenHeight(487),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    SizeConfig.getProportionateScreenWidth(24),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/successsvg.svg',
                                        width: SizeConfig.getProportionateScreenWidth(185),
                                        height: SizeConfig.getProportionateScreenHeight(180),
                                      ),
                                      SizedBox(height: SizeConfig.getProportionateScreenWidth(24)),
                                      Text(
                                        "تبریک میگم!",
                                        style: TextStyle(
                                          fontSize: SizeConfig.getProportionateScreenWidth(24),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: SizeConfig.getProportionateScreenWidth(12)),
                                      Text(
                                        "رمز عبور شما با موفقیت تغییر کرد.\nحالا میتونی با رمزعبور جدید وارد بشی.\nشما تا لحظاتی دیگر به صفحه ورود هدایت می شوید",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: SizeConfig.getProportionateScreenWidth(16),
                                          color: AppColors.grey500,
                                        ),
                                      ),
                                      SizedBox(height: SizeConfig.getProportionateScreenWidth(24)),
                                      RotationTransition(
                                        turns: _controller,
                                        child: SvgPicture.asset('assets/images/progress_bar.svg'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      text: 'ادامه',
                      color: AppColors.primary,
                      width: SizeConfig.getProportionateScreenWidth(98),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.1),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
