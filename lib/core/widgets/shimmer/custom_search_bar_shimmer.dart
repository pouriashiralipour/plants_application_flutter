import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/size_config.dart';

class CustomSearchBarShimmer extends StatelessWidget {
  final bool isLightMode;

  const CustomSearchBarShimmer({super.key, required this.isLightMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.getProportionateScreenWidth(24)),
      child: Shimmer.fromColors(
        baseColor: isLightMode ? Colors.grey[300]! : Colors.grey[700]!,
        highlightColor: isLightMode ? Colors.grey[100]! : Colors.grey[600]!,
        child: Container(
          height: SizeConfig.getProportionateScreenHeight(56),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}
