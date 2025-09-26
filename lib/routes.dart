import 'package:flutter/material.dart';
import 'package:full_plants_ecommerce_app/screens/home/home_screen.dart';

import 'screens/on_boarding/on_boarding.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/welcome/welcome_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routName: (context) => const SplashScreen(),
  WelcomeScreen.routName: (context) => const WelcomeScreen(),
  HomeScreen.routName: (context) => const HomeScreen(),
  OnBoarding.routeName: (context) => const OnBoarding(),
};
