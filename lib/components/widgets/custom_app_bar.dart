import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../auth/auth_repository.dart';
import '../../theme/colors.dart';
import '../../utils/constant.dart';
import '../../utils/size.dart';
import '../custom_progress_bar.dart';

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

    if (!auth.isAuthed || me == null) {
      return Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.getProportionateScreenHeight(52),
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.getProportionateScreenWidth(24)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: SizeConfig.getProportionateScreenWidth(30),
                  backgroundImage: AssetImage(
                    widget.isLightMode
                        ? 'assets/images/profile.png'
                        : 'assets/images/profile_dark.png',
                  ),
                ),
                SizedBox(width: SizeConfig.getProportionateScreenWidth(10)),
                Text(
                  'وقت بخیر 👋',
                  style: TextStyle(
                    color: widget.isLightMode ? AppColors.grey600 : AppColors.grey300,
                    fontSize: SizeConfig.getProportionateFontSize(16),
                    fontWeight: FontWeight.w500,
                  ),
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
                SvgPicture.asset(
                  'assets/images/icons/Heart.svg',
                  height: SizeConfig.getProportionateScreenWidth(24),
                  width: SizeConfig.getProportionateScreenWidth(24),
                  color: widget.isLightMode ? AppColors.grey900 : AppColors.white,
                ),
              ],
            ),
          ],
        ),
      );
    }

    String? avatar = me.profilePic;
    if (!avatar.startsWith('http')) {
      avatar = '${UrlInfo.baseUrl}$avatar';
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
                backgroundImage: NetworkImage(avatar),
              ),
              SizedBox(width: SizeConfig.getProportionateScreenWidth(10)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'صبح بخیر 👋',
                    style: TextStyle(
                      color: widget.isLightMode ? AppColors.grey600 : AppColors.grey300,
                      fontSize: SizeConfig.getProportionateFontSize(16),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  auth.isAuthed
                      ? Text(
                          me.full_name,
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
              SvgPicture.asset(
                'assets/images/icons/Heart.svg',
                height: SizeConfig.getProportionateScreenWidth(24),
                width: SizeConfig.getProportionateScreenWidth(24),
                color: widget.isLightMode ? AppColors.grey900 : AppColors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
