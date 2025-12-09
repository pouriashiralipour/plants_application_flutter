import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/services/intro_prefs.dart';

import '../../../../core/config/root_screen.dart';
import '../../../../core/widgets/app_progress_indicator.dart';
import '../../../welcome/presentation/screens/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RootScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Spacer(),
            Center(child: SvgPicture.asset('assets/images/Logo.svg')),
            Spacer(),
            AppProgressBarIndicator(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
