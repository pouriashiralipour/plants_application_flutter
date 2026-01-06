import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/load_saved_session.dart';
import '../../features/auth/domain/usecases/login_with_otp.dart';
import '../../features/auth/domain/usecases/login_with_password.dart';
import '../../features/auth/domain/usecases/logout.dart';
import '../../features/auth/domain/usecases/refresh_tokens_if_needed.dart';
import '../../features/auth/domain/usecases/request_otp.dart';
import '../../features/auth/domain/usecases/request_password_reset_otp.dart';
import '../../features/auth/domain/usecases/set_new_password.dart';
import '../../features/auth/domain/usecases/verify_password_reset_otp.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/domain/usecases/add_cart_item.dart';
import '../../features/cart/domain/usecases/clear_cart.dart';
import '../../features/cart/domain/usecases/get_cart.dart';
import '../../features/cart/domain/usecases/remove_cart_item.dart';
import '../../features/cart/domain/usecases/update_cart_item_quantity.dart';
import '../../features/cart/presentation/controllers/cart_controller.dart';
import '../../features/product/data/repositories/product_repository_impl.dart';
import '../../features/product/data/repositories/review_repository_impl.dart';
import '../../features/product/domain/repositories/product_repository.dart';
import '../../features/product/domain/repositories/review_repository.dart';
import '../../features/product/domain/usecases/add_product_review.dart';
import '../../features/product/domain/usecases/get_categories.dart';
import '../../features/product/domain/usecases/get_product_by_id.dart';
import '../../features/product/domain/usecases/get_product_reviews.dart';
import '../../features/product/domain/usecases/get_products.dart';
import '../../features/product/domain/usecases/toggle_review_like.dart';
import '../../features/profile/data/repositories/address_repository_impl.dart';
import '../../features/profile/domain/repositories/address_repository.dart';
import '../../features/profile/domain/usecases/add_address.dart';
import '../../features/profile/domain/usecases/get_addresses.dart';
import '../../features/wishlist/data/repositories/wishlist_repository_impl.dart';
import '../../features/wishlist/domain/repositories/wishlist_repository.dart';
import '../../features/wishlist/domain/usecases/get_wishlist.dart';
import '../../features/wishlist/domain/usecases/toggle_wishlist.dart';
import '../services/connectivity_service.dart';
import '../theme/theme_repository.dart';

final connectivityServiceProvider = Provider<ConnectivityService>((ref) => ConnectivityService());

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepositoryImpl());

final themeRepositoryProvider = ChangeNotifierProvider<ThemeRepository>((ref) => ThemeRepository.I);

final loginWithPasswordProvider = Provider<LoginWithPassword>(
  (ref) => LoginWithPassword(ref.watch(authRepositoryProvider)),
);

final loginWithOtpProvider = Provider<LoginWithOtp>(
  (ref) => LoginWithOtp(ref.watch(authRepositoryProvider)),
);

final logoutProvider = Provider<Logout>((ref) => Logout(ref.watch(authRepositoryProvider)));

final loadSavedSessionProvider = Provider<LoadSavedSession>(
  (ref) => LoadSavedSession(ref.watch(authRepositoryProvider)),
);

final refreshTokensIfNeededProvider = Provider<RefreshTokensIfNeeded>(
  (ref) => RefreshTokensIfNeeded(ref.watch(authRepositoryProvider)),
);

final getCurrentUserProvider = Provider<GetCurrentUser>(
  (ref) => GetCurrentUser(ref.watch(authRepositoryProvider)),
);

final requestPasswordResetOtpProvider = Provider<RequestPasswordResetOtp>(
  (ref) => RequestPasswordResetOtp(ref.watch(authRepositoryProvider)),
);

final verifyPasswordResetOtpProvider = Provider<VerifyPasswordResetOtp>(
  (ref) => VerifyPasswordResetOtp(ref.watch(authRepositoryProvider)),
);

final setNewPasswordProvider = Provider<SetNewPassword>(
  (ref) => SetNewPassword(ref.watch(authRepositoryProvider)),
);

final requestOtpProvider = Provider<RequestOtp>(
  (ref) => RequestOtp(ref.watch(authRepositoryProvider)),
);

final productRepositoryProvider = Provider<ProductRepository>((ref) => ProductRepositoryImpl());

final getCategoriesProvider = Provider<GetCategories>(
  (ref) => GetCategories(ref.watch(productRepositoryProvider)),
);

final getProductsProvider = Provider<GetProducts>(
  (ref) => GetProducts(ref.watch(productRepositoryProvider)),
);

final getProductByIdProvider = Provider<GetProductById>(
  (ref) => GetProductById(ref.watch(productRepositoryProvider)),
);

final cartRepositoryProvider = Provider<CartRepository>((ref) => CartRepositoryImpl());

final getCartProvider = Provider<GetCart>((ref) => GetCart(ref.watch(cartRepositoryProvider)));

final addCartItemProvider = Provider<AddCartItem>(
  (ref) => AddCartItem(ref.watch(cartRepositoryProvider)),
);

final updateCartItemQuantityProvider = Provider<UpdateCartItemQuantity>(
  (ref) => UpdateCartItemQuantity(ref.watch(cartRepositoryProvider)),
);

final removeCartItemProvider = Provider<RemoveCartItem>(
  (ref) => RemoveCartItem(ref.watch(cartRepositoryProvider)),
);

final clearCartProvider = Provider<ClearCart>(
  (ref) => ClearCart(ref.watch(cartRepositoryProvider)),
);

final cartControllerProvider = ChangeNotifierProvider<CartController>((ref) {
  final controller = CartController(
    getCart: ref.watch(getCartProvider),
    addCartItem: ref.watch(addCartItemProvider),
    updateCartItemQuantity: ref.watch(updateCartItemQuantityProvider),
    removeCartItem: ref.watch(removeCartItemProvider),
    clearCart: ref.watch(clearCartProvider),
  )..load();
  return controller;
});

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) => ReviewRepositoryImpl());

final getProductReviewsProvider = Provider<GetProductReviews>(
  (ref) => GetProductReviews(ref.watch(reviewRepositoryProvider)),
);

final toggleReviewLikeProvider = Provider<ToggleReviewLike>(
  (ref) => ToggleReviewLike(ref.watch(reviewRepositoryProvider)),
);

final addProductReviewProvider = Provider<AddProductReview>(
  (ref) => AddProductReview(ref.watch(reviewRepositoryProvider)),
);

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) => WishlistRepositoryImpl());

final getWishlistProvider = Provider<GetWishlist>(
  (ref) => GetWishlist(ref.watch(wishlistRepositoryProvider)),
);

final toggleWishlistProvider = Provider<ToggleWishlist>(
  (ref) => ToggleWishlist(ref.watch(wishlistRepositoryProvider)),
);

final addressRepositoryProvider = Provider<AddressRepository>((ref) => AddressRepositoryImpl());

final getAddressesProvider = Provider<GetAddresses>(
  (ref) => GetAddresses(ref.watch(addressRepositoryProvider)),
);

final addAddressProvider = Provider<AddAddress>(
  (ref) => AddAddress(ref.watch(addressRepositoryProvider)),
);
