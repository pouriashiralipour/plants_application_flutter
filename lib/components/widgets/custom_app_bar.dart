import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../auth/auth_repository.dart';
import '../../theme/colors.dart';
import '../../utils/constant.dart';
import '../../utils/size.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, required this.isLightMode});

  final bool isLightMode;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthRepository>();
    final me = auth.me;
    String? avatar = me?.profilePic;
    if (avatar != null && !avatar.startsWith('http')) {
      avatar = '${UrlInfo.baseUrl}$avatar';
    }
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.getProportionateScreenHeight(52),
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.getProportionateScreenWidth(24)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipOval(
                child: auth.isAuthed
                    ? avatar != null
                          ? Image.network(
                              avatar,
                              width: SizeConfig.getProportionateScreenWidth(48) * 2,
                              height: SizeConfig.getProportionateScreenWidth(48) * 2,
                              fit: BoxFit.contain,
                            )
                          : null
                    : Image.asset(
                        isLightMode
                            ? 'assets/images/profile.png'
                            : 'assets/images/profile_dark.png',
                        width: SizeConfig.getProportionateScreenWidth(48) * 2,
                        height: SizeConfig.getProportionateScreenWidth(48) * 2,
                        fit: BoxFit.contain,
                      ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'صبح بخیر 👋',
                    style: TextStyle(
                      color: isLightMode ? AppColors.grey600 : AppColors.grey300,
                      fontSize: SizeConfig.getProportionateFontSize(16),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  auth.isAuthed
                      ? Text(
                          me!.full_name,
                          style: TextStyle(
                            color: isLightMode ? AppColors.grey800 : AppColors.white,
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
                color: isLightMode ? AppColors.grey900 : AppColors.white,
              ),
              SizedBox(width: SizeConfig.getProportionateScreenWidth(16)),
              SvgPicture.asset(
                'assets/images/icons/Heart.svg',
                height: SizeConfig.getProportionateScreenWidth(24),
                width: SizeConfig.getProportionateScreenWidth(24),
                color: isLightMode ? AppColors.grey900 : AppColors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
