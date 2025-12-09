import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../onboarding/presentation/screens/on_boarding.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  static String routeName = './welcome';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _goToOnboarding();
  }

  Future<void> _goToOnboarding() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnBoarding()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: SizeConfig.screenHeight,
            child: Image.asset('assets/images/Image.png', fit: BoxFit.cover),
          ),
          if (Theme.of(context).brightness == Brightness.light)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: SizeConfig.screenHeight * 0.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFF8F8F8).withValues(alpha: 0.0),
                      Color(0xFFF8F8F8).withValues(alpha: 1),
                    ],
                    stops: const [0.1, 0.9],
                  ),
                ),
              ),
            ),
          if (Theme.of(context).brightness == Brightness.dark)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: SizeConfig.screenHeight * 0.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF181A20).withValues(alpha: 0.2),
                      Color(0xFF181A20).withValues(alpha: 1),
                    ],
                    stops: const [0.0, 0.9],
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: SizeConfig.getProportionateScreenHeight(100),
            left: SizeConfig.getProportionateScreenWidth(32),
            right: SizeConfig.getProportionateScreenWidth(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'خوش اومدی به',
                      style: TextStyle(
                        fontSize: SizeConfig.getProportionateFontSize(36),
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Peyda',
                        color: Theme.of(context).brightness == Brightness.light
                            ? AppColors.grey900
                            : AppColors.white,
                      ),
                    ),
                    SizedBox(width: SizeConfig.getProportionateScreenWidth(8)),
                    Text('👋', style: TextStyle(fontSize: SizeConfig.getProportionateFontSize(32))),
                  ],
                ),
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => AppColors.gradientGreen.createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  child: Text(
                    'فیلوروپیا',
                    style: TextStyle(
                      fontSize: SizeConfig.getProportionateFontSize(60),
                      fontWeight: FontWeight.w900,
                      color: AppColors.green,
                      height: 1.3,
                      fontFamily: 'Peyda',
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(16)),
                Text(
                  'آماده‌ای خونه‌ات رو سبز کنیم؟',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: SizeConfig.getProportionateFontSize(20),
                    color: Theme.of(context).brightness == Brightness.light
                        ? AppColors.grey800
                        : AppColors.grey300,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'از گلدون تا باغچه؛ هر چیزی که برای سبز شدن لازم داری، اینجاست',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: SizeConfig.getProportionateFontSize(18),
                    color: Theme.of(context).brightness == Brightness.light
                        ? AppColors.grey800
                        : AppColors.grey300,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
