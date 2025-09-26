import 'dart:async';

import 'package:flutter/material.dart';

import '../on_boarding/on_boarding.dart';
import '../welcome/components/body.dart';

class WelcomeScreen extends StatefulWidget {
  static String routName = './welcome';
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(
      const Duration(seconds: 3),
      () => Navigator.pushNamed(context, OnBoarding.routeName),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Body();
  }
}
