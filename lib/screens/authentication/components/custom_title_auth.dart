import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../../utils/size.dart';

class CustomTitleAuth extends StatelessWidget {
  const CustomTitleAuth({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.grey900,
        fontSize: SizeConfig.getProportionateScreenWidth(28),
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
