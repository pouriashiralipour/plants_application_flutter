import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  const Gap(this.normal, {super.key, this.min = 8, this.keyboardFactor = 0.55});

  final double normal;

  final double min;

  final double keyboardFactor;

  @override
  Widget build(BuildContext context) {
    final kb = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboard = kb > 0;

    final target = isKeyboard ? (normal * keyboardFactor) : normal;

    final clamped = target < min ? min : target;

    return AnimatedSize(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      child: SizedBox(height: clamped),
    );
  }
}
