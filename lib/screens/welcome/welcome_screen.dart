import 'package:flutter/material.dart';

import '../welcome/components/body.dart';

class WelcomeScreen extends StatelessWidget {
  static String routName = './welcome';
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Body();
  }
}
