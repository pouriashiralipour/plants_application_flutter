import 'package:flutter/material.dart';

import 'routes.dart';
import 'screens/splash/splash_screen.dart';
import 'theme/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'utils/size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        SizeConfig.init(context);
        return MaterialApp(
          title: 'Poteo Application',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('fa')],
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routes: routes,
          initialRoute: SplashScreen.routeName,
        );
      },
    );
  }
}
