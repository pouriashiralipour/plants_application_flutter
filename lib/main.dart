import 'package:flutter/material.dart';
import 'features/product/presentation/controllers/product_search_controller.dart';

import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/services/app_message_controller.dart';
import 'core/utils/size_config.dart';
import 'core/widgets/app_toast_layer.dart';
import 'core/services/connectivity_service.dart';
import 'core/theme/theme_repository.dart';
import 'core/theme/app_theme.dart';

import 'features/cart/data/repository/cart_repository.dart';
import 'features/profile/data/epositories/address_repository.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/data/repositories/password_reset_repository.dart';
import 'features/product/data/repositories/product_repository.dart';
import 'features/wishlist/data/repositories/wishlist_repository.dart';
import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/domain/repositories/product_repository.dart';
import 'features/product/domain/usecases/get_categories.dart';
import 'features/product/domain/usecases/get_product_by_id.dart';
import 'features/product/domain/usecases/get_products.dart';
import 'features/product/presentation/controllers/product_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeRepository.I.init();
  await AuthRepository.I.init();
  await CartRepository.I.init();

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
        ChangeNotifierProvider<ShopRepository>.value(value: ShopRepository.I),
        Provider<ProductRepository>(create: (_) => ProductRepositoryImpl()),
        Provider<GetCategories>(
          create: (context) => GetCategories(context.read<ProductRepository>()),
        ),
        Provider<GetProducts>(create: (context) => GetProducts(context.read<ProductRepository>())),
        Provider<GetProductById>(
          create: (context) => GetProductById(context.read<ProductRepository>()),
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

        ChangeNotifierProvider<WishlistRepository>.value(value: WishlistRepository.I),
        ChangeNotifierProvider<CartRepository>.value(value: CartRepository.I),
        ChangeNotifierProvider<AddressRepository>.value(value: AddressRepository.I),
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
