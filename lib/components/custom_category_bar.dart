import 'package:flutter/material.dart';
import 'package:full_plants_ecommerce_app/components/widgets/shimmer/custom_category_bar_shimmer.dart';
import 'package:provider/provider.dart';

import '../auth/shop_repository.dart';
import '../theme/colors.dart';
import '../utils/size.dart';

class CustomCategoryBar extends StatefulWidget {
  const CustomCategoryBar({super.key, required this.indexCategory, this.onCategoryChanged});

  final int indexCategory;
  final VoidCallback? onCategoryChanged;

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

        if (widget.onCategoryChanged != null) {
          widget.onCategoryChanged!();
        }
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

  bool _categoryHasProducts(String categoryName, ShopRepository shopRepository) {
    if (categoryName.isEmpty) return false;

    if (shopRepository.allProducts.isEmpty) return true;

    return shopRepository.allProducts.any((product) {
      return product.category.name == categoryName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final shopRepository = context.watch<ShopRepository>();
    final categories = shopRepository.categories;
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;

    if (categories.isEmpty) {
      return CustomCategoryBarShimmer(isLightMode: isLightMode);
    }

    final filteredCategories = categories.where((category) {
      return _categoryHasProducts(category.name, shopRepository);
    }).toList();

    if (filteredCategories.isEmpty) {
      return Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.getProportionateScreenHeight(38),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [_buildCategoryItem(-1, 'همه', null)]),
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
            ...filteredCategories.asMap().entries.map((entry) {
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
