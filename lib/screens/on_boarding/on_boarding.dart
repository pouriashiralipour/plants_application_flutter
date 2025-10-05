import 'package:flutter/material.dart';

import '../../models/on_boarding_models.dart';
import '../../services/intro_prefs.dart';

import '../../theme/colors.dart';
import '../../utils/size.dart';
import '../root/root_screen.dart';

class OnBoarding extends StatefulWidget {
  static String routeName = './onBoarding';
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  @override
  void initState() {
    super.initState();
    _guardIfAlreadyDone();
  }

  int currentIndex = 0;
  PageController pageController = PageController(initialPage: 0);

  void _finishOnboarding() async {
    await IntroPrefs.setIntroDone();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, RootScreen.routeName, (route) => false);
  }

  Future<void> _guardIfAlreadyDone() async {
    final done = await IntroPrefs.isIntroDone();
    if (!mounted) return;
    if (done) {
      Navigator.pushReplacementNamed(context, RootScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? AppColors.bgSilver1
          : AppColors.dark1,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              itemCount: OnBoardingModels.items.length,
              controller: pageController,
              scrollDirection: Axis.horizontal,
              onPageChanged: (int page) {
                setState(() {
                  currentIndex = page;
                });
              },
              itemBuilder: (context, index) {
                final item = OnBoardingModels.items[index];
                return Padding(
                  padding: EdgeInsets.only(top: SizeConfig.getProportionateScreenHeight(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: SizeConfig.getProportionateScreenHeight(400),
                        width: SizeConfig.getProportionateScreenWidth(400),
                        child: Image.asset(item['image'], fit: BoxFit.cover),
                      ),
                      SizedBox(height: SizeConfig.getProportionateScreenHeight(40)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.getProportionateScreenWidth(24),
                        ),
                        child: Text(
                          item['content'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.light
                                ? AppColors.grey900
                                : AppColors.white,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Peyda',
                            fontSize: SizeConfig.getProportionateScreenWidth(21),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              bottom: SizeConfig.getProportionateScreenHeight(154),
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(OnBoardingModels.items.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    margin: EdgeInsets.only(right: SizeConfig.getProportionateScreenWidth(6)),
                    width: currentIndex == index
                        ? SizeConfig.getProportionateScreenWidth(32)
                        : SizeConfig.getProportionateScreenWidth(8),
                    height: SizeConfig.getProportionateScreenWidth(8),
                    decoration: BoxDecoration(
                      gradient: currentIndex == index ? AppColors.gradientGreen : null,
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).brightness == Brightness.light
                          ? currentIndex != index
                                ? AppColors.grey300
                                : null
                          : currentIndex != index
                          ? AppColors.dark3
                          : null,
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.getProportionateScreenHeight(48)),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    if (currentIndex == 2) {
                      _finishOnboarding();
                    } else {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.linear,
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    width: currentIndex == 2
                        ? SizeConfig.getProportionateScreenWidth(120)
                        : SizeConfig.getProportionateScreenWidth(67),
                    height: SizeConfig.getProportionateScreenHeight(58),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        if (Theme.of(context).brightness == Brightness.light)
                          BoxShadow(
                            offset: Offset(4, 8),
                            blurRadius: 24,
                            spreadRadius: 0,
                            color: AppColors.primary.withValues(alpha: 0.25),
                          ),
                        if (Theme.of(context).brightness == Brightness.dark)
                          BoxShadow(
                            offset: Offset(4, 8),
                            blurRadius: 12,
                            spreadRadius: 0,
                            color: AppColors.primary.withValues(alpha: 0.25),
                          ),
                      ],
                    ),
                    child: Text(
                      currentIndex == 2 ? 'بزن بریم' : 'بعدی',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: SizeConfig.getProportionateScreenWidth(18),
                        fontFamily: 'Peyda',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
