import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../../utils/size.dart';

class RememberMeWidget extends StatefulWidget {
  const RememberMeWidget({super.key});

  @override
  State<RememberMeWidget> createState() => _RememberMeWidgetState();
}

class _RememberMeWidgetState extends State<RememberMeWidget> {
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 8),
        Text(
          "منو یادت باشه",
          style: TextStyle(
            fontSize: SizeConfig.getProportionateScreenWidth(14),
            fontWeight: FontWeight.w600,
            color: AppColors.grey900,
          ),
        ),
        Checkbox(
          value: _isChecked,
          onChanged: (value) {
            setState(() {
              _isChecked = value!;
            });
          },
          activeColor: AppColors.primary,
          side: BorderSide(
            color: AppColors.primary,
            width: 3,
            style: BorderStyle.solid,
            strokeAlign: 1,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ],
    );
  }
}
