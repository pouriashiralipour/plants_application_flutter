import 'package:flutter/material.dart';
import 'package:full_plants_ecommerce_app/screens/home/home_screen.dart';

import 'screens/authentication/change_password_screen.dart';
import 'screens/authentication/forgot_password_screen.dart';
import 'screens/authentication/login_screen.dart';
import 'screens/authentication/profile_form_screen.dart';
import 'screens/authentication/sign_up_screen.dart';
import 'screens/on_boarding/on_boarding.dart';
import 'screens/root/root_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/welcome/welcome_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  WelcomeScreen.routeName: (context) => const WelcomeScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  OnBoarding.routeName: (context) => const OnBoarding(),
  RootScreen.routeName: (context) => const RootScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  // OTPScreen.routeName: (context) => const OTPScreen(),
  LoginScreen.routeName: (contxet) => const LoginScreen(),
  ForgotPasswordScreen.routeName: (contxet) => const ForgotPasswordScreen(),
  ChangePasswordScreen.routeName: (contxet) => const ChangePasswordScreen(),
  ProfileFormScreen.routeName: (contxet) => const ProfileFormScreen(),
};
