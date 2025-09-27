import 'dart:async';

import 'package:flutter/material.dart';

import '../on_boarding/on_boarding.dart';
import '../welcome/components/body.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  static String routeName = './welcome';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _goToOnboarding();
  }

  Future<void> _goToOnboarding() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, OnBoarding.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Body();
  }
}
