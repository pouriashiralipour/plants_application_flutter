import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../../utils/size.dart';

class CustomTitleAuth extends StatelessWidget {
  const CustomTitleAuth({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: isLightMode ? AppColors.grey900 : AppColors.white,
        fontSize: SizeConfig.getProportionateFontSize(22),
        fontWeight: FontWeight.w900,
        fontFamily: 'Peyda',
      ),
    );
  }
}
