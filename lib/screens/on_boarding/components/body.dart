import 'package:flutter/material.dart';

import '../../../models/on_boarding_models.dart';
import '../../../theme/colors.dart';
import '../../../utils/size.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentIndex = 0;
  PageController pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSilver1,
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
                            color: AppColors.grey900,
                            fontWeight: FontWeight.w700,
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
                      color: currentIndex != index ? AppColors.grey300 : null,
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
                      // go to next page
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
                        BoxShadow(
                          offset: Offset(4, 8),
                          blurRadius: 24,
                          spreadRadius: 0,
                          color: AppColors.primary.withValues(alpha: 0.25),
                        ),
                      ],
                    ),
                    child: Text(
                      currentIndex == 2 ? 'بزن بریم' : 'بعدی',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: SizeConfig.getProportionateScreenWidth(20),
                        fontFamily: 'IranYekan',
                        fontWeight: FontWeight.w800,
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
