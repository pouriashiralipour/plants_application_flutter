import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/colors.dart';
import '../utils/size.dart';

class CustomBackArrow extends StatelessWidget {
  const CustomBackArrow({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: SizeConfig.getProportionateScreenWidth(24),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: SvgPicture.asset('assets/images/icons/back_aroow.svg', color: AppColors.grey900),
      ),
    );
  }
}
