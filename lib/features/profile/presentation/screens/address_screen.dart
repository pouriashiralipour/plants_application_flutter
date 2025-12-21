import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/size_config.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'آدرس ها',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.grey900,
            fontSize: SizeConfig.getProportionateFontSize(21),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(
              horizontal: SizeConfig.getProportionateScreenWidth(24),
            ),
            child: Column(
              children: [
                Container(
                  width: SizeConfig.getProportionateScreenWidth(380),
                  height: SizeConfig.getProportionateScreenHeight(92),
                  child: Row(
                    children: [
                      Container(
                        width: SizeConfig.getProportionateScreenWidth(52),
                        height: SizeConfig.getProportionateScreenWidth(52),
                        decoration: BoxDecoration(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
