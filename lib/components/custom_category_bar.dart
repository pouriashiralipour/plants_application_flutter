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
    _currentIndex = -1;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final shopRepository = context.read<ShopRepository>();
      if (!shopRepository.categoriesLoaded) {
        shopRepository.loadCategories();
      }
      shopRepository.filterProductsByCategory(null);
    });
  }

  Widget _buildCategoryItem(int index, String name, String? categoryName) {
    final shopRepository = context.read<ShopRepository>();
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
        shopRepository.filterProductsByCategory(categoryName);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 900),
        height: SizeConfig.getProportionateScreenHeight(38),
        margin: EdgeInsets.only(
          right: index == -1
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
          color: isSelected ? AppColors.primary : null,
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.primary,
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




    if (categories.isEmpty) {
      return SizedBox(
        height: SizeConfig.getProportionateScreenHeight(38),
        child: Center(
          child: Text(
            'در حال دریافت دسته‌بندی‌ها...',
            style: TextStyle(
              color: AppColors.grey700,
              fontSize: SizeConfig.getProportionateFontSize(14),
            ),
          ),
        ),
      );
    }

    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.getProportionateScreenHeight(38),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildCategoryItem(-1, 'همه', null),
            ...categories.asMap().entries.map((entry) {
              final index = entry.key;
              final category = entry.value;
              return _buildCategoryItem(index, category.name, category.name);
            }).toList(),
          ],
        ),
      ),
    );
  }
}
