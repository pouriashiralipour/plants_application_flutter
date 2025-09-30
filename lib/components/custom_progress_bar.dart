import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CusstomProgressBar extends StatefulWidget {
  const CusstomProgressBar({super.key});

  @override
  State<CusstomProgressBar> createState() => _CusstomProgressBarState();
}

class _CusstomProgressBarState extends State<CusstomProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: SvgPicture.asset('assets/images/progress_bar.svg'),
    );
  }
}
