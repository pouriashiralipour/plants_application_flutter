import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/wishlist/presentation/controllers/wishlist_controller.dart';
import '../theme/app_colors.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/wallet/presentation/screens/wallet_screen.dart';
import '../utils/size_config.dart';

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

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final auth = context.read<AuthController>();
      if (auth.isAuthed) {
        context.read<WishlistController>().load();
      }
    });
  }

  Container customNavBar() {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.getProportionateScreenHeight(18)),
      height: SizeConfig.getProportionateScreenHeight(60),
      width: SizeConfig.screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_screens.length, (index) {
          final item = _items[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  if (index == 4) {
                    final isAuthed = context.read<AuthController>().isAuthed;
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
                      if (context.mounted && context.read<AuthController>().isAuthed) {
                        setState(() => bottonIndex = 4);
                      }
                      return;
                    }
                  }
                  setState(() => bottonIndex = index);
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  curve: Curves.elasticOut,
                  padding: EdgeInsets.all(SizeConfig.getProportionateScreenWidth(4)),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: bottonIndex == index
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: bottonIndex == index
                        ? Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1)
                        : Border.all(color: Colors.transparent, width: 0),
                  ),
                  transform: Matrix4.identity()..scale(bottonIndex == index ? 1.1 : 1.0),
                  child: SvgPicture.asset(
                    bottonIndex == index ? item['fill_icon'] : item['icon'],
                    colorFilter: .mode(
                      bottonIndex == index ? AppColors.primary : AppColors.grey500,
                      .srcIn,
                    ),
                    height: SizeConfig.getProportionateScreenWidth(22),
                    width: SizeConfig.getProportionateScreenWidth(22),
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.getProportionateScreenHeight(5)),
              Text(
                item['lable'],
                style: TextStyle(
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
    final authed = context.watch<AuthController>().isAuthed;
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
