import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../../utils/size.dart';

class Body extends StatelessWidget {
  const Body({super.key});

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
                      'خوش آمدید به',
                      style: TextStyle(
                        fontSize: SizeConfig.getProportionateScreenWidth(36),
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).brightness == Brightness.light
                            ? AppColors.grey900
                            : AppColors.white,
                      ),
                    ),
                    SizedBox(width: SizeConfig.getProportionateScreenWidth(8)),
                    Text(
                      '👋',
                      style: TextStyle(fontSize: SizeConfig.getProportionateScreenWidth(32)),
                    ),
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
                      fontSize: SizeConfig.getProportionateScreenWidth(60),
                      fontWeight: FontWeight.bold,
                      color: AppColors.green,
                      height: 1.3,
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.getProportionateScreenHeight(16)),
                Text(
                  'بهترین پلتفرم فروشگاهی گیاه در کشور بر اساس نیاز شما !',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontFamily: 'IranYekan',
                    fontSize: SizeConfig.getProportionateScreenWidth(18),
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
