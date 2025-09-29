import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 8),
        Text(
          "مرا بخاطر بسپار",
          style: TextStyle(
            fontSize: SizeConfig.getProportionateScreenWidth(14),
            fontWeight: FontWeight.w600,
            color: isLightMode ? AppColors.grey900 : AppColors.white,
          ),
        ),
        SizedBox(width: SizeConfig.getProportionateScreenWidth(10)),
        GestureDetector(
          onTap: () {
            setState(() {
              _isChecked = !_isChecked;
            });
          },
          child: SvgPicture.asset(
            _isChecked
                ? 'assets/images/icons/TickSquare_bold.svg'
                : 'assets/images/icons/Rectangle.svg',
            width: SizeConfig.getProportionateScreenWidth(24),
            height: SizeConfig.getProportionateScreenWidth(24),
          ),
        ),
      ],
    );
  }
}
