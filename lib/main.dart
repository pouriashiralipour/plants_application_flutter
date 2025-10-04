import 'package:flutter/material.dart';

import 'routes.dart';
import 'screens/authentication/profile_form_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
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
          themeMode: ThemeMode.system,
          routes: routes,
          initialRoute: ProfileFormScreen.routeName,
        );
      },
    );
  }
}
