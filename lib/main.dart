import 'package:flutter/material.dart';

import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/utils/size_config.dart';
import 'features/cart/data/repository/cart_repository.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/data/repositories/password_reset_repository.dart';
import 'features/product/data/repositories/product_repository.dart';
import 'core/services/connectivity_service.dart';
import 'core/theme/theme_repository.dart';
import 'core/theme/app_theme.dart';
import 'features/wishlist/data/repositories/wishlist_repository.dart';

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
        ChangeNotifierProvider<WishlistRepository>.value(value: WishlistRepository.I),
        ChangeNotifierProvider<CartRepository>.value(value: CartRepository.I),
        ChangeNotifierProvider<PasswordResetRepository>(create: (_) => PasswordResetRepository()),
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
                home: SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
