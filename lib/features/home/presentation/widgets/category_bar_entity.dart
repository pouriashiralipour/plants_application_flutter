import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/shimmer/custom_category_bar_shimmer.dart';
import '../../../product/presentation/controllers/product_controller.dart';

class CategoryBarEntity extends StatefulWidget {
  const CategoryBarEntity({super.key, required this.indexCategory, this.onCategoryChanged});

  final int indexCategory;
  final VoidCallback? onCategoryChanged;

  @override
  State<CategoryBarEntity> createState() => _CategoryBarEntityState();
}

class _CategoryBarEntityState extends State<CategoryBarEntity> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.indexCategory;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<ProductController>();
      if (!controller.categoriesLoaded) {
        controller.loadCategories();
      }
    });
  }

  Widget _buildCategoryItem(int index, String title, String? categoryName) {
    final controller = context.read<ProductController>();
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });

        controller.filterProductsByCategory(categoryName);

        widget.onCategoryChanged?.call();
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
          title,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.primary,
            fontSize: SizeConfig.getProportionateFontSize(14),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  bool _categoryHasProducts(String categoryName, ProductController controller) {
    if (categoryName.isEmpty) return false;

    // اگر لیست پیش‌فرض هنوز لود نشده، دسته‌ها را حذف نکنیم.
    if (controller.allProducts.isEmpty) return true;

    return controller.allProducts.any((p) => p.category.name == categoryName);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProductController>();
    final categories = controller.categories;
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;

    if (categories.isEmpty) {
      return CustomCategoryBarShimmer(isLightMode: isLightMode);
    }

    final filteredCategories = categories.where((c) {
      return _categoryHasProducts(c.name, controller);
    }).toList();

    return SizedBox(
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
