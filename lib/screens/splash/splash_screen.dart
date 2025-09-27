import 'dart:async';

import 'package:flutter/material.dart';
import 'package:full_plants_ecommerce_app/screens/on_boarding/on_boarding.dart';

import '../welcome/welcome_screen.dart';
import 'components/body.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = './splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  @override
  void initState() {
    super.initState();

    _timer = Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, WelcomeScreen.routeName);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return const Body();
  }
}
