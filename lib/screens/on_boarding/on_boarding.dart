import 'package:flutter/material.dart';

import '../../services/intro_prefs.dart';

import '../root/root_screen.dart';
import 'components/body.dart';

class OnBoarding extends StatefulWidget {
  static String routeName = './onBoarding';
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  @override
  void initState() {
    super.initState();
    _guardIfAlreadyDone();
  }

  Future<void> _guardIfAlreadyDone() async {
    final done = await IntroPrefs.isIntroDone();
    if (!mounted) return;
    if (done) {
      Navigator.pushReplacementNamed(context, RootScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Body();
  }
}
