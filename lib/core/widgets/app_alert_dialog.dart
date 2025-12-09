import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../utils/size_config.dart';

class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog({
    super.key,
    required this.text,
    this.isError = false,
    this.isWarning = false,
  });

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
      constraints: BoxConstraints(minHeight: SizeConfig.getProportionateScreenHeight(40)),
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
            width: SizeConfig.getProportionateScreenWidth(18),
            height: SizeConfig.getProportionateScreenWidth(18),
          ),
          SizedBox(width: SizeConfig.getProportionateScreenWidth(8)),
          Expanded(
            child: Text(
              text,
              softWrap: true,
              maxLines: null,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.start,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: _getColor(isError, isWarning),
                fontSize: SizeConfig.getProportionateFontSize(12),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
