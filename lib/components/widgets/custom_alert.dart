import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:full_plants_ecommerce_app/theme/colors.dart';

import '../../utils/size.dart';

class CustomAlert extends StatelessWidget {
  const CustomAlert({super.key, required this.text, this.isError = false, this.isWarning = false});

  final bool isError;
  final bool isWarning;
  final String text;

  @override
  Widget build(BuildContext context) {
    Color _getBackgroundColor(bool isError, bool isWarning) {
      if (isError) {
        return AppColors.error;
      }
      if (isWarning) {
        return AppColors.warning;
      } else {
        return AppColors.success;
      }
    }

    Color _getColor(bool isError, bool isWarning) {
      if (isError) {
        return AppColors.error;
      }
      if (isWarning) {
        return AppColors.orange;
      } else {
        return AppColors.green;
      }
    }

    return Container(
      height: SizeConfig.getProportionateScreenHeight(40),
      decoration: BoxDecoration(
        color: _getBackgroundColor(isError, isWarning).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          SizedBox(width: SizeConfig.getProportionateScreenWidth(12)),
          SvgPicture.asset(
            'assets/images/icons/InfoCircle.svg',
            color: _getColor(isError, isWarning),
          ),
          SizedBox(width: SizeConfig.getProportionateScreenWidth(6)),
          Text(
            text,
            style: TextStyle(
              color: _getColor(isError, isWarning),
              fontSize: SizeConfig.getProportionateFontSize(12),
            ),
          ),
        ],
      ),
    );
  }
}
