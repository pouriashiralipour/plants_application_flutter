import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppProgressBarIndicator extends StatefulWidget {
  const AppProgressBarIndicator({super.key});

  @override
  State<AppProgressBarIndicator> createState() => _AppProgressBarIndicatorState();
}

class _AppProgressBarIndicatorState extends State<AppProgressBarIndicator>
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
