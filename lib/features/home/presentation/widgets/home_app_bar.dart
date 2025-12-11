import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import '../../../../core/config/app_constants.dart';

import '../../../../core/widgets/app_logo.dart';
import '../../../wishlist/presentation/screens/wishlist_screen.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key, required this.isLightMode});

  final bool isLightMode;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthRepository>();
    final me = auth.me;
    final avatarUrl = buildAvatarUrl(me?.profilePic);
    ;

    if (!auth.isAuthed || me == null) {
      return Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.getProportionateScreenHeight(52),
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.getProportionateScreenWidth(24)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppLogo(iconSize: 40, textSize: 32),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/images/icons/Notification.svg',
                  height: SizeConfig.getProportionateScreenWidth(24),
                  width: SizeConfig.getProportionateScreenWidth(24),
                  color: widget.isLightMode ? AppColors.grey900 : AppColors.white,
                ),
                SizedBox(width: SizeConfig.getProportionateScreenWidth(16)),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => WishlistScreen()));
                  },
                  icon: SvgPicture.asset(
                    'assets/images/icons/Heart.svg',
                    height: SizeConfig.getProportionateScreenWidth(24),
                    width: SizeConfig.getProportionateScreenWidth(24),
                    color: widget.isLightMode ? AppColors.grey900 : AppColors.white,
                  ),
                ),
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
              CircleAvatar(
                radius: SizeConfig.getProportionateScreenWidth(30),
                backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                backgroundColor: widget.isLightMode ? AppColors.grey200 : AppColors.dark3,
                child: avatarUrl == null
                    ? Icon(
                        Icons.person,
                        color: widget.isLightMode ? AppColors.grey600 : AppColors.grey100,
                      )
                    : null,
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
                  auth.isAuthed
                      ? Text(
                          '${me.firstName} جان',
                          style: TextStyle(
                            color: widget.isLightMode ? AppColors.grey800 : AppColors.white,
                            fontSize: SizeConfig.getProportionateFontSize(18),
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : Text(''),
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
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => WishlistScreen()));
                },
                icon: SvgPicture.asset(
                  'assets/images/icons/Heart.svg',
                  height: SizeConfig.getProportionateScreenWidth(24),
                  width: SizeConfig.getProportionateScreenWidth(24),
                  color: widget.isLightMode ? AppColors.grey900 : AppColors.white,
                ),
              ),
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
