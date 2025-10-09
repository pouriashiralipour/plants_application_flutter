import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:full_plants_ecommerce_app/auth/auth_repository.dart';
import 'package:full_plants_ecommerce_app/screens/authentication/login/login_screen.dart';
import 'package:provider/provider.dart';


import '../../theme/colors.dart';
import '../../utils/size.dart';
import '../cart/cart_screen.dart';
import '../home/home_screen.dart';
import '../orders/orders_screen.dart';
import '../profile/profile_screen.dart';
import '../wallet/wallet_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  List<Widget> _screens = [
    HomeScreen(),
    CartScreen(),
    OrdersScreen(),
    WalletScreen(),
    ProfileScreen(),
  ];
  List _items = [
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
  int bottonIndex = 0;

  Container customNavBar() {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.getProportionateScreenHeight(25)),
      height: SizeConfig.getProportionateScreenHeight(48),
      width: SizeConfig.screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_screens.length, (index) {
          final item = _items[index];
          return Column(
            children: [
              GestureDetector(
                onTap: () async {
                  if (index == 4) {
                    final isAuthed = context.read<AuthRepository>().isAuthed;
                    if (!isAuthed) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) {
                            return LoginScreen();
                          },
                        ),
                      );
                      if (context.mounted && context.read<AuthRepository>().isAuthed) {
                        setState(() => bottonIndex = 4);
                      }
                      return;
                    }
                  }
                  setState(() => bottonIndex = index);
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
                  fontFamily: 'Peyda',
                  color: bottonIndex == index ? AppColors.primary : AppColors.grey500,
                  fontSize: bottonIndex == index
                      ? SizeConfig.getProportionateFontSize(12)
                      : SizeConfig.getProportionateFontSize(10),
                  fontWeight: bottonIndex == index ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authed = context.watch<AuthRepository>().isAuthed;
    final screens = [
      const HomeScreen(),
      const CartScreen(),
      const OrdersScreen(),
      const WalletScreen(),
      authed ? const ProfileScreen() : const LoginScreen(),
    ];
    return Scaffold(
      bottomNavigationBar: customNavBar(),
      body: IndexedStack(index: bottonIndex, children: screens),
    );
  }
}
