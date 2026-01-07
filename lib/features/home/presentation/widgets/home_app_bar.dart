import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/config/app_constants.dart';
import '../../../../core/widgets/login_required_sheet.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

import '../../../../core/widgets/app_logo.dart';
import '../../../wishlist/presentation/screens/wishlist_screen.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key, required this.isLightMode, required this.loginBuilder});

  final bool isLightMode;
  final WidgetBuilder loginBuilder;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  Future<void> _openWishlist() async {
    final auth = context.read<AuthController>();
    final me = auth.user;

    if (auth.isAuthed && me != null) {
      if (!mounted) return;
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WishlistScreen()));
      return;
    }

    final goLogin = await showLoginRequiredSheet(
      context: context,
      title: 'علاقه‌مندی‌ها',
      message: 'برای مشاهده ی لیست علاقه‌مندی‌ها ابتدا وارد حساب کاربری شوید.',
      icon: "assets/images/icons/HeartBold.svg",
      loginText: 'ورود / ثبت‌نام',
      cancelText: 'بعداً',
    );

    if (goLogin != true || !mounted) return;

    await Navigator.of(
      context,
    ).push(MaterialPageRoute(fullscreenDialog: true, builder: widget.loginBuilder));

    if (!mounted) return;

    final authAfter = context.read<AuthController>();
    final meAfter = authAfter.user;

    if (authAfter.isAuthed && meAfter != null) {
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WishlistScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final me = auth.user;

    final avatarUrl = buildAvatarUrl(me?.profilePic);

    final heartButton = IconButton(
      onPressed: _openWishlist,
      icon: SvgPicture.asset(
        'assets/images/icons/Heart.svg',
        height: SizeConfig.getProportionateScreenWidth(24),
        width: SizeConfig.getProportionateScreenWidth(24),
        color: widget.isLightMode ? AppColors.grey900 : AppColors.white,
      ),
    );

    if (!auth.isAuthed || me == null) {
      return Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.getProportionateScreenHeight(52),
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.getProportionateScreenWidth(24)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppLogo(iconSize: 40, textSize: 32),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/images/icons/Notification.svg',
                  height: SizeConfig.getProportionateScreenWidth(24),
                  width: SizeConfig.getProportionateScreenWidth(24),
                  color: widget.isLightMode ? AppColors.grey900 : AppColors.white,
                ),
                SizedBox(width: SizeConfig.getProportionateScreenWidth(16)),
                heartButton,
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      key: ValueKey(auth.isAuthed),
      width: SizeConfig.screenWidth,
      height: SizeConfig.getProportionateScreenHeight(52),
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.getProportionateScreenWidth(24)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: BoxBorder.all(color: AppColors.primary, width: 2),
                ),
                child: CircleAvatar(
                  radius: SizeConfig.getProportionateScreenWidth(30),
                  backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                  backgroundColor: widget.isLightMode ? AppColors.grey200 : AppColors.dark3,
                  child: avatarUrl == null
                      ? Image.asset(
                          widget.isLightMode
                              ? 'assets/images/profile.png'
                              : 'assets/images/profile_dark.png',
                        )
                      : null,
                ),
              ),
              SizedBox(width: SizeConfig.getProportionateScreenWidth(10)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ' وقت بخیر 👋',
                    style: TextStyle(
                      color: widget.isLightMode ? AppColors.grey600 : AppColors.grey300,
                      fontSize: SizeConfig.getProportionateFontSize(16),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${me.firstName} جان',
                    style: TextStyle(
                      color: widget.isLightMode ? AppColors.grey800 : AppColors.white,
                      fontSize: SizeConfig.getProportionateFontSize(18),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              SvgPicture.asset(
                'assets/images/icons/Notification.svg',
                height: SizeConfig.getProportionateScreenWidth(24),
                width: SizeConfig.getProportionateScreenWidth(24),
                color: widget.isLightMode ? AppColors.grey900 : AppColors.white,
              ),
              SizedBox(width: SizeConfig.getProportionateScreenWidth(16)),
              heartButton,
            ],
          ),
        ],
      ),
    );
  }
}

String? buildAvatarUrl(String? raw) {
  if (raw == null) return null;

  final avatar = raw.trim();
  if (avatar.isEmpty) return null;

  if (avatar.startsWith('http')) {
    return avatar;
  }

  if (avatar.startsWith('/')) {
    return '${UrlInfo.baseUrl}${avatar.substring(1)}';
  }

  return '${UrlInfo.baseUrl}$avatar';
}
