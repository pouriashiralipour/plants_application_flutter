import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import 'features/cart/domain/usecases/get_cart.dart';
import 'features/cart/domain/usecases/clear_cart.dart';
import 'features/product/data/repositories/review_repository_impl.dart';
import 'features/product/domain/repositories/review_repository.dart';
import 'features/product/domain/usecases/get_product_reviews.dart';
import 'features/product/domain/usecases/toggle_review_like.dart';
import 'features/product/domain/usecases/add_product_review.dart';
import 'features/cart/presentation/controllers/cart_controller.dart';

import 'features/cart/domain/usecases/add_cart_item.dart';
import 'features/cart/domain/usecases/update_cart_item_quantity.dart';
import 'features/cart/domain/usecases/remove_cart_item.dart';
import 'features/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'features/wishlist/domain/repositories/wishlist_repository.dart';
import 'features/wishlist/domain/usecases/get_wishlist.dart';
import 'features/wishlist/domain/usecases/add_to_wishlist.dart';
import 'features/wishlist/domain/usecases/remove_from_wishlist.dart';
import 'features/wishlist/domain/usecases/toggle_wishlist.dart';
import 'features/product/presentation/controllers/product_search_controller.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/data/repositories/password_reset_repository.dart';
import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/domain/repositories/product_repository.dart';
import 'features/product/domain/usecases/get_categories.dart';
import 'features/product/domain/usecases/get_product_by_id.dart';
import 'features/product/domain/usecases/get_products.dart';
import 'features/product/presentation/controllers/product_controller.dart';
import 'features/cart/data/repositories/cart_repository_impl.dart';
import 'features/cart/domain/repositories/cart_repository.dart';
import 'features/wishlist/presentation/controllers/wishlist_controller.dart';
import 'features/profile/data/repositories/address_repository_impl.dart';
import 'features/profile/domain/repositories/address_repository.dart';
import 'features/profile/domain/usecases/add_address.dart';
import 'features/profile/domain/usecases/get_addresses.dart';
import 'features/profile/presentation/controllers/address_controller.dart';

import 'core/services/app_message_controller.dart';
import 'core/utils/size_config.dart';
import 'core/widgets/app_toast_layer.dart';
import 'core/services/connectivity_service.dart';
import 'core/theme/theme_repository.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeRepository.I.init();
  await AuthRepository.I.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeRepository>.value(value: ThemeRepository.I),
        ChangeNotifierProvider<AuthRepository>.value(value: AuthRepository.I),
        Provider<ProductRepository>(create: (_) => ProductRepositoryImpl()),
        Provider<GetCategories>(
          create: (context) => GetCategories(context.read<ProductRepository>()),
        ),
        Provider<GetProducts>(create: (context) => GetProducts(context.read<ProductRepository>())),
        Provider<GetProductById>(
          create: (context) => GetProductById(context.read<ProductRepository>()),
        ),
        Provider<CartRepository>(create: (_) => CartRepositoryImpl()),
        Provider<GetCart>(create: (context) => GetCart(context.read<CartRepository>())),
        Provider<AddCartItem>(create: (context) => AddCartItem(context.read<CartRepository>())),
        Provider<UpdateCartItemQuantity>(
          create: (context) => UpdateCartItemQuantity(context.read<CartRepository>()),
        ),
        Provider<RemoveCartItem>(
          create: (context) => RemoveCartItem(context.read<CartRepository>()),
        ),
        Provider<ClearCart>(create: (context) => ClearCart(context.read<CartRepository>())),

        Provider<ReviewRepository>(create: (_) => ReviewRepositoryImpl()),
        Provider<GetProductReviews>(
          create: (context) => GetProductReviews(context.read<ReviewRepository>()),
        ),
        Provider<ToggleReviewLike>(
          create: (context) => ToggleReviewLike(context.read<ReviewRepository>()),
        ),
        Provider<AddProductReview>(
          create: (context) => AddProductReview(context.read<ReviewRepository>()),
        ),
        Provider<WishlistRepository>(create: (_) => WishlistRepositoryImpl()),
        Provider<GetWishlist>(create: (context) => GetWishlist(context.read<WishlistRepository>())),
        Provider<AddToWishlist>(
          create: (context) => AddToWishlist(context.read<WishlistRepository>()),
        ),
        Provider<RemoveFromWishlist>(
          create: (context) => RemoveFromWishlist(context.read<WishlistRepository>()),
        ),
        Provider<ToggleWishlist>(
          create: (context) => ToggleWishlist(context.read<WishlistRepository>()),
        ),
        Provider<AddressRepository>(create: (_) => AddressRepositoryImpl()),
        Provider<GetAddresses>(
          create: (context) => GetAddresses(context.read<AddressRepository>()),
        ),
        Provider<AddAddress>(create: (context) => AddAddress(context.read<AddressRepository>())),
        ChangeNotifierProvider<AddressController>(
          create: (context) => AddressController(
            getAddresses: context.read<GetAddresses>(),
            addAddress: context.read<AddAddress>(),
          )..load(),
        ),

        ChangeNotifierProvider<ProductController>(
          create: (context) => ProductController(
            getCategories: context.read<GetCategories>(),
            getProducts: context.read<GetProducts>(),
            getProductById: context.read<GetProductById>(),
          ),
        ),
        ChangeNotifierProvider<ProductSearchController>(
          create: (context) => ProductSearchController(
            getCategories: context.read<GetCategories>(),
            getProducts: context.read<GetProducts>(),
          ),
        ),
        ChangeNotifierProvider<CartController>(
          create: (context) => CartController(
            getCart: context.read<GetCart>(),
            addCartItem: context.read<AddCartItem>(),
            updateCartItemQuantity: context.read<UpdateCartItemQuantity>(),
            removeCartItem: context.read<RemoveCartItem>(),
            clearCart: context.read<ClearCart>(),
          )..load(),
        ),
        ChangeNotifierProvider<WishlistController>(
          create: (context) => WishlistController(
            getWishlist: context.read<GetWishlist>(),
            toggleWishlist: context.read<ToggleWishlist>(),
          )..load(),
        ),
        ChangeNotifierProvider<PasswordResetRepository>(create: (_) => PasswordResetRepository()),
        ChangeNotifierProvider<AppMessageController>(create: (_) => AppMessageController()),

        Provider(create: (_) => ConnectivityService()),
      ],
      child: Consumer<ThemeRepository>(
        builder: (_, theme, __) {
          return LayoutBuilder(
            builder: (context, constraints) {
              SizeConfig.init(context);
              return MaterialApp(
                title: 'Philoroupia Application',
                debugShowCheckedModeBanner: false,
                locale: const Locale("fa", "IR"),
                supportedLocales: const [Locale("fa", "IR"), Locale("en", "US")],
                localizationsDelegates: [
                  PersianMaterialLocalizations.delegate,
                  PersianCupertinoLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: theme.themeMode,
                builder: (context, child) {
                  return Stack(children: [if (child != null) child, const AppToastLayer()]);
                },
                home: SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
