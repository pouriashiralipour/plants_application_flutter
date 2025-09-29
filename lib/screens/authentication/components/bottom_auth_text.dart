import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../../utils/size.dart';

class BottomAuthText extends StatelessWidget {
  const BottomAuthText({
    super.key,
    required this.text,
    required this.buttonText,
    required this.onTap,
  });

  final String text;
  final String buttonText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: SizeConfig.getProportionateScreenWidth(14),
            color: isLightMode ? AppColors.grey500 : AppColors.white,
          ),
        ),
        SizedBox(width: SizeConfig.getProportionateScreenWidth(5)),
        GestureDetector(
          onTap: onTap,
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: SizeConfig.getProportionateScreenWidth(14),
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
