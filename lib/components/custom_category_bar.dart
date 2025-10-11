import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/shop_repository.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final shopRepository = context.read<ShopRepository>();
      if (!shopRepository.categoriesLoaded) {
        shopRepository.loadCategories();
      }
    });
  }

  Widget _buildCategoryItem(int index, String name) {
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
          name,
          style: TextStyle(
            color: _currentIndex == index ? AppColors.white : AppColors.primary,
            fontSize: SizeConfig.getProportionateFontSize(14),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shopRepository = context.watch<ShopRepository>();
    final categories = shopRepository.categories;

    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.getProportionateScreenHeight(38),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildCategoryItem(-1, 'همه'),
            ...categories.asMap().entries.map((entry) {
              final index = entry.key;
              final category = entry.value;
              return _buildCategoryItem(index, category.name);
            }).toList(),
          ],
        ),
      ),
    );
  }
}
