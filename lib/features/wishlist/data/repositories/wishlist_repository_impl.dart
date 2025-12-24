import '../../domain/entities/wishlist_item.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/wishlist_remote_data_source.dart';
import '../mappers/wishlist_item_model_mapper.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  WishlistRepositoryImpl({WishlistApi? api}) : _api = api ?? WishlistApi.I;

  final WishlistApi _api;

  @override
  Future<WishlistItem> add({required String productId}) async {
    final result = await _api.add(productId);

    if (!result.success || result.data == null) {
      throw Exception(result.error ?? 'خطا در افزودن به علاقه‌مندی‌ها');
    }

    return result.data!.toEntity();
  }

  @override
  Future<List<WishlistItem>> getWishlist() async {
    final result = await _api.getAll();

    if (!result.success || result.data == null) {
      throw Exception(result.error ?? 'خطا در دریافت لیست علاقه‌مندی‌ها');
    }

    return result.data!.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> remove({required String wishlistItemId}) async {
    final result = await _api.remove(wishlistItemId);

    if (!result.success) {
      throw Exception(result.error ?? 'خطا در حذف از علاقه‌مندی‌ها');
    }
  }

  @override
  Future<List<WishlistItem>> toggle({required String productId}) async {
    final current = await getWishlist();

    final existing = current.where((w) => w.product.id == productId).toList();
    if (existing.isNotEmpty) {
      await remove(wishlistItemId: existing.first.id);
    } else {
      await add(productId: productId);
    }

    return getWishlist();
  }
}
