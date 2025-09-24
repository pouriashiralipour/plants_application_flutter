import 'dart:async';

import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import 'components/body.dart';

class SplashScreen extends StatefulWidget {
  static String routName = './splash';
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
      Navigator.pushNamed(context, HomeScreen.routName);
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
