import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/persian_number.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/gap.dart';
import '../screens/search_screen.dart';

class SearchFilterResult {
  SearchFilterResult({
    this.category,
    this.minPrice,
    this.maxPrice,
    this.rating,
    required this.sortOption,
  });

  final String? category;
  final int? maxPrice;
  final int? minPrice;
  final int? rating;
  final SearchSortOption sortOption;
}

class SearchFilterSheet extends StatefulWidget {
  const SearchFilterSheet({
    super.key,
    required this.isLightMode,
    required this.categories,
    this.initialCategory,
    this.initialMinPrice,
    this.initialMaxPrice,
    this.initialRating,
    required this.initialSortOption,
  });

  final List<String> categories;
  final String? initialCategory;
  final int? initialMaxPrice;
  final int? initialMinPrice;
  final int? initialRating;
  final SearchSortOption initialSortOption;
  final bool isLightMode;

  @override
  State<SearchFilterSheet> createState() => _SearchFilterSheetState();
}

class _SearchFilterSheetState extends State<SearchFilterSheet> {
  static const List<double> _barHeights = <double>[18, 32, 26, 40, 30, 36, 22, 28, 20, 34, 26, 30];
  static const int _maxPrice = 100000000;
  static const int _minPrice = 0;

  late RangeValues _priceRange;
  late SearchSortOption _sortOption;

  late String? _selectedCategory;
  late int? _selectedRating;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _selectedRating = widget.initialRating;
    _sortOption = widget.initialSortOption;

    final double start = (widget.initialMinPrice ?? _minPrice).toDouble();
    final double end = (widget.initialMaxPrice ?? _maxPrice).toDouble();
    _priceRange = RangeValues(start, end);
  }

  Widget _buildPriceHistogramBackground(bool isLightMode) {
    final int barCount = _barHeights.length;
    final double step = (_maxPrice - _minPrice) / barCount;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(barCount, (int index) {
          final double centerValue = _minPrice + step * (index + 0.5);
          final bool inRange = centerValue >= _priceRange.start && centerValue <= _priceRange.end;

          final Color barColor = AppColors.primary.withValues(alpha: inRange ? 0.24 : 0.08);

          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.getProportionateScreenWidth(2)),
              child: Container(
                height: _barHeights[index],
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: barColor),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: SizeConfig.getProportionateFontSize(14),
        fontWeight: FontWeight.w700,
        color: widget.isLightMode ? AppColors.grey900 : AppColors.white,
      ),
    );
  }

  void _reset() {
    setState(() {
      _selectedCategory = null;
      _selectedRating = null;
      _sortOption = SearchSortOption.popular;
      _priceRange = RangeValues(_minPrice.toDouble(), _maxPrice.toDouble());
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = widget.isLightMode;
    final startDisplay = (_priceRange.start.toInt() ~/ 10);
    final endDisplay = (_priceRange.end.toInt() ~/ 10);

    return Container(
      decoration: BoxDecoration(
        color: isLightMode ? AppColors.white : AppColors.dark2,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.getProportionateScreenWidth(20),
        vertical: SizeConfig.getProportionateScreenHeight(16),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: SizeConfig.getProportionateScreenWidth(40),
                  height: 4,
                  decoration: BoxDecoration(
                    color: isLightMode ? AppColors.grey300 : AppColors.dark3,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              Gap(SizeConfig.getProportionateScreenHeight(16)),
              Center(
                child: Text(
                  'مرتب‌سازی و فیلتر',
                  style: TextStyle(
                    fontSize: SizeConfig.getProportionateFontSize(18),
                    fontWeight: FontWeight.w900,
                    color: isLightMode ? AppColors.grey900 : AppColors.white,
                  ),
                ),
              ),
              Gap(SizeConfig.getProportionateScreenHeight(16)),
              Divider(
                color: isLightMode ? AppColors.grey200 : AppColors.dark3,
                thickness: 1,
                height: SizeConfig.getProportionateScreenHeight(16),
              ),
              Gap(SizeConfig.getProportionateScreenHeight(12)),
              _buildSectionTitle('دسته‌بندی‌ها'),
              Gap(SizeConfig.getProportionateScreenHeight(12)),
              Wrap(
                spacing: SizeConfig.getProportionateScreenWidth(8),
                runSpacing: SizeConfig.getProportionateScreenHeight(8),
                children: [
                  _CategoryChip(
                    label: 'همه',
                    selected: _selectedCategory == null,
                    isLightMode: isLightMode,
                    onTap: () {
                      setState(() {
                        _selectedCategory = null;
                      });
                    },
                  ),
                  ...widget.categories.map(
                    (String cactegory) => _CategoryChip(
                      label: cactegory,
                      selected: _selectedCategory == cactegory,
                      isLightMode: isLightMode,
                      onTap: () {
                        setState(() {
                          _selectedCategory = cactegory;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Gap(SizeConfig.getProportionateScreenHeight(24)),
              _buildSectionTitle('بازه قیمت'),
              SizedBox(
                height: SizeConfig.getProportionateScreenHeight(110),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Positioned.fill(child: _buildPriceHistogramBackground(isLightMode)),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 4,
                          activeTrackColor: AppColors.primary,
                          inactiveTrackColor: isLightMode ? AppColors.grey200 : AppColors.dark3,

                          rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 12),
                        ),
                        child: RangeSlider(
                          values: _priceRange,
                          min: _minPrice.toDouble(),
                          max: _maxPrice.toDouble(),
                          onChanged: (values) {
                            setState(() {
                              _priceRange = values;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(SizeConfig.getProportionateScreenHeight(4)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${startDisplay.toString().priceFormatter} تومان'.farsiNumber,
                    style: TextStyle(
                      fontSize: SizeConfig.getProportionateFontSize(12),
                      fontWeight: FontWeight.w600,
                      color: isLightMode ? AppColors.grey700 : AppColors.grey300,
                    ),
                  ),
                  Text(
                    '${endDisplay.toString().priceFormatter} تومان'.farsiNumber,
                    style: TextStyle(
                      fontSize: SizeConfig.getProportionateFontSize(12),
                      fontWeight: FontWeight.w600,
                      color: isLightMode ? AppColors.grey700 : AppColors.grey300,
                    ),
                  ),
                ],
              ),

              Gap(SizeConfig.getProportionateScreenHeight(24)),

              _buildSectionTitle('مرتب‌سازی بر اساس'),
              Gap(SizeConfig.getProportionateScreenHeight(12)),
              Wrap(
                spacing: SizeConfig.getProportionateScreenWidth(8),
                runSpacing: SizeConfig.getProportionateScreenHeight(8),
                children: [
                  _FilterChip(
                    label: 'محبوب‌ترین',
                    selected: _sortOption == SearchSortOption.popular,
                    isLightMode: isLightMode,
                    onTap: () {
                      setState(() {
                        _sortOption = SearchSortOption.popular;
                      });
                    },
                  ),
                  _FilterChip(
                    label: 'جدیدترین',
                    selected: _sortOption == SearchSortOption.mostRecent,
                    isLightMode: isLightMode,
                    onTap: () {
                      setState(() {
                        _sortOption = SearchSortOption.mostRecent;
                      });
                    },
                  ),
                  _FilterChip(
                    label: 'بیشترین قیمت',
                    selected: _sortOption == SearchSortOption.priceHigh,
                    isLightMode: isLightMode,
                    onTap: () {
                      setState(() {
                        _sortOption = SearchSortOption.priceHigh;
                      });
                    },
                  ),
                  _FilterChip(
                    label: 'کمترین قیمت',
                    selected: _sortOption == SearchSortOption.priceLow,
                    isLightMode: isLightMode,
                    onTap: () {
                      setState(() {
                        _sortOption = SearchSortOption.priceLow;
                      });
                    },
                  ),
                ],
              ),

              Gap(SizeConfig.getProportionateScreenHeight(24)),

              _buildSectionTitle('امتیاز'),
              Gap(SizeConfig.getProportionateScreenHeight(8)),
              Wrap(
                spacing: SizeConfig.getProportionateScreenWidth(8),
                runSpacing: SizeConfig.getProportionateScreenHeight(8),
                children: [
                  _RatingChip(
                    label: 'همه',
                    stars: null,
                    selected: _selectedRating == null,
                    isLightMode: isLightMode,
                    onTap: () {
                      setState(() {
                        _selectedRating = null;
                      });
                    },
                  ),
                  ...[5, 4, 3, 2, 1].map(
                    (int rating) => _RatingChip(
                      label: '$rating',
                      stars: rating,
                      selected: _selectedRating == rating,
                      isLightMode: isLightMode,
                      onTap: () {
                        setState(() {
                          _selectedRating = rating;
                        });
                      },
                    ),
                  ),
                ],
              ),

              Gap(SizeConfig.getProportionateScreenHeight(24)),

              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      width: 50,
                      onTap: _reset,
                      text: 'ریست',
                      isShadow: false,
                      color: isLightMode ? AppColors.bgSilver1 : AppColors.dark3,
                      textColor: AppColors.primary,
                      fontSize: SizeConfig.getProportionateFontSize(13),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: AppButton(
                      width: 50,
                      onTap: () {
                        Navigator.pop(
                          context,
                          SearchFilterResult(
                            category: _selectedCategory,
                            minPrice: _priceRange.start.toInt(),
                            maxPrice: _priceRange.end.toInt(),
                            rating: _selectedRating,
                            sortOption: _sortOption,
                          ),
                        );
                      },
                      text: 'اعمال فیلتر',
                      color: AppColors.primary,
                      fontSize: SizeConfig.getProportionateFontSize(13),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.isLightMode,
    required this.onTap,
  });

  final bool isLightMode;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getProportionateScreenWidth(12),
          vertical: SizeConfig.getProportionateScreenHeight(6),
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : (isLightMode ? AppColors.bgSilver1 : AppColors.dark2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.primary : AppColors.primary),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.getProportionateFontSize(14),
            color: selected ? AppColors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.isLightMode,
    required this.onTap,
  });

  final bool isLightMode;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getProportionateScreenWidth(12),
          vertical: SizeConfig.getProportionateScreenHeight(6),
        ),
        decoration: BoxDecoration(
          border: BoxBorder.all(color: AppColors.primary, width: 1),
          color: selected
              ? AppColors.primary
              : (isLightMode ? AppColors.bgSilver1 : AppColors.dark2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: SizeConfig.getProportionateFontSize(14),
            fontWeight: FontWeight.bold,
            color: selected ? AppColors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _RatingChip extends StatelessWidget {
  const _RatingChip({
    required this.label,
    required this.stars,
    required this.selected,
    required this.isLightMode,
    required this.onTap,
  });

  final bool isLightMode;
  final String label;
  final VoidCallback onTap;
  final bool selected;
  final int? stars;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = selected
        ? AppColors.primary
        : (isLightMode ? AppColors.bgSilver1 : AppColors.dark2);
    final Color textColor = selected ? AppColors.white : AppColors.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getProportionateScreenWidth(10),
          vertical: SizeConfig.getProportionateScreenHeight(6),
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: BoxBorder.all(color: AppColors.primary),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (stars != null) ...[
              Icon(
                Icons.star,
                size: SizeConfig.getProportionateScreenWidth(14),
                color: selected ? AppColors.white : AppColors.primary,
              ),
              SizedBox(width: SizeConfig.getProportionateScreenWidth(4)),
            ],
            Text(
              label.farsiNumber,
              style: TextStyle(
                fontSize: SizeConfig.getProportionateFontSize(12),
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
