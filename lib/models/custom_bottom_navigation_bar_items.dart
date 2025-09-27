import 'package:flutter/material.dart';

import '../screens/cart/cart_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/orders/orders_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/wallet/wallet_screen.dart';

class CustomBottomNavigationBarItems {
  static List<Widget> screens() {
    return [HomeScreen(), CartScreen(), OrdersScreen(), WalletScreen(), ProfileScreen()];
  }

  static List items = [
    {
      'icon': 'assets/images/icons/Home.svg',
      'fill_icon': 'assets/images/icons/Home_fill.svg',
      'lable': 'خانه',
    },
    {
      'icon': 'assets/images/icons/Bag.svg',
      'fill_icon': 'assets/images/icons/Bag_fill.svg',
      'lable': 'سبد خرید',
    },
    {
      'icon': 'assets/images/icons/Buy.svg',
      'fill_icon': 'assets/images/icons/buy_fill.svg',
      'lable': 'سفارش ها',
    },
    {
      'icon': 'assets/images/icons/Wallet.svg',
      'fill_icon': 'assets/images/icons/Wallet_fill.svg',
      'lable': 'کیف پول',
    },
    {
      'icon': 'assets/images/icons/Profile.svg',
      'fill_icon': 'assets/images/icons/Profile_fill.svg',
      'lable': 'پروفایل',
    },
  ];
}
