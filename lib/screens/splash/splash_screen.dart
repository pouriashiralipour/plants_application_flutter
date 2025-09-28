import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:full_plants_ecommerce_app/utils/size.dart';
import '../../services/intro_prefs.dart';

import '../root/root_screen.dart';
import '../welcome/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static String routeName = './splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _decideNext();

    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _decideNext() async {
    await Future.delayed(const Duration(seconds: 3));

    final done = await IntroPrefs.isIntroDone();
    if (!mounted) return;

    if (done) {
      Navigator.pushReplacementNamed(context, RootScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context, WelcomeScreen.routeName);
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
            Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.getProportionateScreenHeight(60)),
              child: RotationTransition(
                turns: _controller,
                child: SvgPicture.asset('assets/images/progress_bar.svg'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
