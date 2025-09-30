import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/colors.dart';
import '../utils/size.dart';
import 'custom_progress_bar.dart';

class CustomSuccessDialog extends StatelessWidget {
  const CustomSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(44)),
      child: SizedBox(
        width: SizeConfig.getProportionateScreenWidth(340),
        height: SizeConfig.getProportionateScreenHeight(487),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(24)),
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
                  color: isLightMode ? AppColors.grey500 : AppColors.white,
                ),
              ),
              SizedBox(height: SizeConfig.getProportionateScreenWidth(24)),
              CusstomProgressBar(),
            ],
          ),
        ),
      ),
    );
  }
}
