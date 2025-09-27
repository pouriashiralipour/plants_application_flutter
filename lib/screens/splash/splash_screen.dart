import 'dart:async';
import 'package:flutter/material.dart';

import '../../services/intro_prefs.dart';
import '../home/home_screen.dart';
import '../welcome/welcome_screen.dart';
import 'components/body.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static String routeName = './splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  @override
  void initState() {
    super.initState();
    _decideNext();
  }

  Future<void> _decideNext() async {
    await Future.delayed(const Duration(seconds: 3));

    final done = await IntroPrefs.isIntroDone();
    if (!mounted) return;

    if (done) {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context, WelcomeScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Body();
  }
}
