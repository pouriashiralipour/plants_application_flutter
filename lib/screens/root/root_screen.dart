import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/custom_bottom_navigation_bar_items.dart';
import '../../theme/colors.dart';
import '../../utils/size.dart';

class RootScreen extends StatefulWidget {
  static String routeName = './routes';
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int bottonIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottonIndex,
        onTap: (index) {
          setState(() {
            bottonIndex = index;
          });
        },
        showUnselectedLabels: true,
        type: BottomNavigationBarType.shifting,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey500,
        selectedLabelStyle: TextStyle(
          fontSize: SizeConfig.getProportionateScreenWidth(12),
          fontWeight: FontWeight.w800,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: SizeConfig.getProportionateScreenWidth(10),
          fontWeight: FontWeight.w600,
        ),
        items: List.generate(CustomBottomNavigationBarItems.items.length, (index) {
          final item = CustomBottomNavigationBarItems.items[index];
          final isSelected = index == bottonIndex;
          return BottomNavigationBarItem(
            icon: SvgPicture.asset(
              item['icon'],
              width: isSelected
                  ? SizeConfig.getProportionateScreenWidth(26)
                  : SizeConfig.getProportionateScreenWidth(24),
              height: isSelected
                  ? SizeConfig.getProportionateScreenWidth(26)
                  : SizeConfig.getProportionateScreenWidth(24),
              // ignore: deprecated_member_use
              color: isSelected ? AppColors.primary : AppColors.grey500,
            ),
            activeIcon: SvgPicture.asset(
              item['fill_icon'],
              width: isSelected
                  ? SizeConfig.getProportionateScreenWidth(26)
                  : SizeConfig.getProportionateScreenWidth(24),
              height: isSelected
                  ? SizeConfig.getProportionateScreenWidth(26)
                  : SizeConfig.getProportionateScreenWidth(24),
              color: isSelected ? AppColors.primary : AppColors.grey500,
            ),
            label: item['lable'],
          );
        }),
      ),
      body: IndexedStack(index: bottonIndex, children: CustomBottomNavigationBarItems.screens()),
    );
  }
}
