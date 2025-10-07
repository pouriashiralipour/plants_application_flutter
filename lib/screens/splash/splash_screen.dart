import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../components/custom_progress_bar.dart';
import '../../services/intro_prefs.dart';

import '../root/root_screen.dart';
import '../welcome/welcome_screen.dart';

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
            CusstomProgressBar(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
