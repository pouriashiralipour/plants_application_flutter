import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../utils/size.dart';

class CustomCategoryBar extends StatefulWidget {
  const CustomCategoryBar({super.key, required this.indexCategory});

  final int indexCategory;

  @override
  State<CustomCategoryBar> createState() => _CustomCategoryBarState();
}

class _CustomCategoryBarState extends State<CustomCategoryBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.indexCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.getProportionateScreenHeight(38),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(6, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 900),
                height: SizeConfig.getProportionateScreenHeight(38),
                margin: EdgeInsets.only(
                  right: index == 0
                      ? SizeConfig.getProportionateScreenWidth(24)
                      : SizeConfig.getProportionateScreenWidth(12),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProportionateScreenWidth(20),
                  vertical: SizeConfig.getProportionateScreenHeight(8),
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: BoxBorder.all(width: 2, color: AppColors.primary),
                  borderRadius: BorderRadius.circular(100),
                  color: _currentIndex == index ? AppColors.primary : null,
                ),
                child: Text(
                  'همه',
                  style: TextStyle(
                    color: _currentIndex == index ? AppColors.white : AppColors.primary,
                    fontSize: SizeConfig.getProportionateScreenWidth(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
