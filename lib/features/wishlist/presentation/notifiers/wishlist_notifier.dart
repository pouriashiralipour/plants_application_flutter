import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/wishlist_repository_impl.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../../domain/usecases/get_wishlist.dart';
import '../../domain/usecases/toggle_wishlist.dart';
import 'wishlist_state.dart';

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) => WishlistRepositoryImpl());

final getWishListProvider = Provider<GetWishlist>(
  (ref) => GetWishlist(ref.watch(wishlistRepositoryProvider)),
);

final toggleWishlistProvider = Provider<ToggleWishlist>(
  (ref) => ToggleWishlist(ref.watch(wishlistRepositoryProvider)),
);

class WishlistNotifier extends Notifier<WishlistState> {
  late final GetWishlist _getWishlist;
  late final ToggleWishlist _toggleWishlist;

  Future<void> load() async {
    await _run(errorPrefix: 'خطا در دریافت علاقه‌مندی‌ها', action: () => _getWishlist());
  }

  Future<void> toggle({required String productId}) async {
    await _run(
      errorPrefix: 'خطا در تغییر علاقه‌مندی',
      action: () => _toggleWishlist(productId: productId),
    );
  }

  Future<void> _run({
    required String errorPrefix,
    required Future<List<dynamic>> Function() action,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final items = await action();
      state = state.copyWith(items: items.cast(), isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '$errorPrefix: $e');
    }
  }

  @override
  WishlistState build() {
    _getWishlist = ref.watch(getWishListProvider);
    _toggleWishlist = ref.watch(toggleWishlistProvider);

    unawaited(Future.microtask(load));
    return const WishlistState(items: [], isLoading: true, error: null);
  }
}
