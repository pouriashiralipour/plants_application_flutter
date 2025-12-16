import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:full_plants_ecommerce_app/core/utils/persian_number.dart';
import 'package:full_plants_ecommerce_app/core/widgets/app_search_bar.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/connectivity_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/app_progress_indicator.dart';
import '../../../../core/widgets/gap.dart';
import '../../../offline/presentation/screens/offline_screen.dart';
import '../../data/repositories/product_repository.dart';
import '../widgets/product_grid.dart';
import '../widgets/search_filter_sheet.dart';

enum SearchSortOption { popular, mostRecent, priceHigh, priceLow }

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchCtrl = TextEditingController();
  final _searchFocus = FocusNode();

  bool _isCheckingInternet = true;
  bool _isOnline = true;
  bool _isSearching = false;
  bool _hasSearched = false;
  bool _isFocused = false;

  String _query = '';
  String? _error;
  String? _ordering;

  String? _selectedCategory;
  int? _priceMin;
  int? _priceMax;
  int? _rating;
  SearchSortOption _sortOption = SearchSortOption.popular;

  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _initializeApp();

    _searchFocus.addListener(() {
      setState(() {
        _isFocused = _searchFocus.hasFocus;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await _checkInternetConnection();

    if (!mounted) return;

    final shopRepository = context.read<ShopRepository>();
    if (shopRepository.categories.isEmpty) {
      await shopRepository.loadCategories();
    }
  }

  Future<void> _checkInternetConnection() async {
    if (mounted) {
      setState(() {
        _isCheckingInternet = true;
      });
    }

    try {
      final connectivityService = context.read<ConnectivityService>();
      final isConnected = await connectivityService.checkInternetConnection();

      if (mounted) {
        setState(() {
          _isOnline = isConnected;
          _isCheckingInternet = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isOnline = false;
          _isCheckingInternet = false;
        });
      }
    }
  }

  String? _mapOrdering(SearchSortOption option) {
    switch (option) {
      case SearchSortOption.popular:
        return '-sales_count';
      case SearchSortOption.mostRecent:
        return '-created_at';
      case SearchSortOption.priceHigh:
        return '-price';
      case SearchSortOption.priceLow:
        return 'price';
    }
  }

  Future<void> _openFilterSheet(bool isLightMode) async {
    final shopRepository = context.read<ShopRepository>();
    final categories = shopRepository.categories.map((c) => c.name).toList();

    final result = await showModalBottomSheet<SearchFilterResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SearchFilterSheet(
          isLightMode: isLightMode,
          categories: categories,
          initialCategory: _selectedCategory,
          initialMinPrice: _priceMin,
          initialMaxPrice: _priceMax,
          initialRating: _rating,
          initialSortOption: _sortOption,
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedCategory = result.category;
        _priceMin = result.minPrice;
        _priceMax = result.maxPrice;
        _rating = result.rating;
        _sortOption = result.sortOption;
        _ordering = _mapOrdering(result.sortOption);
      });

      await _performSearch(triggeredByFilter: true);
    }
  }

  Future<void> _performSearch({bool triggeredByFilter = false}) async {
    final shopRepository = context.read<ShopRepository>();
    final q = _searchCtrl.text.trim();

    final hasAnyFilter =
        _selectedCategory != null || _priceMin != null || _priceMax != null || _rating != null;

    if (q.isEmpty && !hasAnyFilter && !triggeredByFilter) {
      return;
    }

    setState(() {
      _isSearching = true;
      _hasSearched = true;
      _error = null;
      _query = q;
    });

    try {
      await shopRepository.loadProducts(
        search: q.isEmpty ? null : q,
        category: _selectedCategory,
        priceMin: _priceMin,
        priceMax: _priceMax,
        rating: _rating,
        ordering: _ordering,
        forceRefresh: true,
      );

      if (q.isNotEmpty) {
        _recentSearches.remove(q);
        _recentSearches.insert(0, q);
        if (_recentSearches.length > 10) {
          _recentSearches = _recentSearches.sublist(0, 10);
        }
      }

      if (!mounted) return;

      if (shopRepository.error != null) {
        setState(() {
          _error = shopRepository.error;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'خطا در جستجو. لطفاً دوباره تلاش کنید.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  Widget _buildRecentSearches(bool isLightMode) {
    if (_recentSearches.isEmpty) {
      return Center(
        child: Text(
          'عبارتی را جستجو کنید تا اینجا نمایش داده شود.',
          style: TextStyle(
            color: isLightMode ? AppColors.grey600 : AppColors.grey300,
            fontSize: SizeConfig.getProportionateFontSize(14),
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'جستجوهای اخیر',
          style: TextStyle(
            fontSize: SizeConfig.getProportionateFontSize(14),
            fontWeight: FontWeight.w700,
            color: isLightMode ? AppColors.grey900 : AppColors.white,
          ),
        ),
        Gap(SizeConfig.getProportionateScreenHeight(12)),
        Expanded(
          child: ListView.separated(
            itemCount: _recentSearches.length,
            separatorBuilder: (_, __) => Gap(SizeConfig.getProportionateScreenHeight(8)),
            itemBuilder: (context, index) {
              final term = _recentSearches[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  term,
                  style: TextStyle(
                    color: isLightMode ? AppColors.grey800 : AppColors.grey200,
                    fontSize: SizeConfig.getProportionateFontSize(14),
                  ),
                ),
                trailing: Icon(Icons.north_west, size: 18, color: AppColors.grey400),
                onTap: () {
                  _searchCtrl.text = term;
                  _searchCtrl.selection = TextSelection.collapsed(offset: term.length);
                  _performSearch();
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNotFound(bool isLightMode) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.getProportionateScreenWidth(32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              isLightMode
                  ? 'assets/images/cart_empty_light.svg'
                  : 'assets/images/cart_empty_dark.svg',
            ),
            Gap(SizeConfig.getProportionateScreenHeight(24)),
            Text(
              'نتیجه‌ای برای "${_query}" پیدا نشد',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: SizeConfig.getProportionateFontSize(16),
                fontWeight: FontWeight.w700,
                color: isLightMode ? AppColors.grey900 : AppColors.white,
              ),
            ),
            Gap(SizeConfig.getProportionateScreenHeight(8)),
            Text(
              'لطفاً عبارت دیگری را امتحان کن یا فیلترها را تغییر بده.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: SizeConfig.getProportionateFontSize(13),
                color: isLightMode ? AppColors.grey600 : AppColors.grey300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    final shopRepository = context.watch<ShopRepository>();
    final products = shopRepository.products;

    if (!_isOnline) {
      return OfflineScreen(onRetry: _checkInternetConnection);
    }

    if (_isCheckingInternet) {
      return const Center(child: AppProgressBarIndicator());
    }

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.getProportionateScreenHeight(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSearchBar(
                  readOnly: false,
                  filterOnTap: () => _openFilterSheet(isLightMode),
                  focusNode: _searchFocus,
                  isLightMode: isLightMode,
                  isFocused: _isFocused,
                  onTap: () {},
                  controller: _searchCtrl,
                  onSubmitted: (_) => _performSearch(),
                  onChanged: (value) {
                    _query = value;
                  },
                ),

                if (_hasSearched)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.getProportionateScreenWidth(24),
                      vertical: SizeConfig.getProportionateScreenHeight(24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: 'نتایج برای ',
                              style: TextStyle(
                                fontFamily: 'Vazirmatn',
                                fontSize: SizeConfig.getProportionateFontSize(14),
                                fontWeight: FontWeight.w600,
                                color: isLightMode ? AppColors.grey900 : AppColors.white,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '"${_query}"',
                                  style: TextStyle(
                                    fontFamily: 'Vazirmatn',
                                    fontSize: SizeConfig.getProportionateFontSize(16),
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (!_isSearching)
                          Text(
                            '${products.length} مورد'.farsiNumber,
                            style: TextStyle(
                              fontSize: SizeConfig.getProportionateFontSize(14),
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ),

                Expanded(
                  child: _isSearching
                      ? const Center(child: AppProgressBarIndicator())
                      : !_hasSearched
                      ? _buildRecentSearches(isLightMode)
                      : _error != null
                      ? Center(
                          child: Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.error,
                              fontSize: SizeConfig.getProportionateFontSize(14),
                            ),
                          ),
                        )
                      : products.isEmpty
                      ? _buildNotFound(isLightMode)
                      : ProductGrid(shopRepository: shopRepository, isLightMode: isLightMode),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
