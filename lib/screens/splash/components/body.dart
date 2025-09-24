import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:full_plants_ecommerce_app/utils/size.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(child: SvgPicture.asset('assets/images/Logo.svg')),
          Padding(
            padding: EdgeInsetsGeometry.only(bottom: SizeConfig.screenHeight * 0.15),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset('assets/images/progress_bar.svg'),
            ),
          ),
        ],
      ),
    );
  }
}
