import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/size.dart';

class AuthSvgAssetWidget extends StatelessWidget {
  const AuthSvgAssetWidget({super.key, required this.svg});

  final String svg;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svg,
      width: SizeConfig.getProportionateScreenWidth(150),
      height: SizeConfig.getProportionateScreenHeight(150),
    );
  }
}
