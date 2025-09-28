import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/custom_bottom_navigation_bar_items.dart';
import '../../theme/colors.dart';
import '../../utils/size.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  static String routeName = './routes';

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int bottonIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: customNavBar(),
      body: IndexedStack(index: bottonIndex, children: CustomBottomNavigationBarItems.screens()),
    );
  }

  Container customNavBar() {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.getProportionateScreenHeight(25)),
      height: SizeConfig.getProportionateScreenHeight(48),
      width: SizeConfig.screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(CustomBottomNavigationBarItems.screens().length, (index) {
          final item = CustomBottomNavigationBarItems.items[index];
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    bottonIndex = index;
                  });
                },
                child: SvgPicture.asset(
                  bottonIndex == index ? item['fill_icon'] : item['icon'],
                  color: bottonIndex == index ? AppColors.primary : AppColors.grey500,
                  height: bottonIndex == index
                      ? SizeConfig.getProportionateScreenWidth(26)
                      : SizeConfig.getProportionateScreenWidth(24),
                  width: bottonIndex == index
                      ? SizeConfig.getProportionateScreenWidth(26)
                      : SizeConfig.getProportionateScreenWidth(24),
                ),
              ),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(5)),
              Text(
                item['lable'],
                style: TextStyle(
                  color: bottonIndex == index ? AppColors.primary : AppColors.grey500,
                  fontSize: bottonIndex == index
                      ? SizeConfig.getProportionateScreenWidth(12)
                      : SizeConfig.getProportionateScreenWidth(10),
                  fontWeight: bottonIndex == index ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
