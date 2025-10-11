import 'package:flutter/material.dart';

import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'screens/splash/splash_screen.dart';
import 'auth/auth_repository.dart';
import 'auth/password_reset_repository.dart';
import 'auth/shop_repository.dart';
import 'theme/theme_repository.dart';
import 'theme/theme.dart';
import 'utils/size.dart';

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
        ChangeNotifierProvider<ShopRepository>.value(value: ShopRepository.I),
        ChangeNotifierProvider<PasswordResetRepository>(create: (_) => PasswordResetRepository()),
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
