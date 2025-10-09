import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:full_plants_ecommerce_app/theme/theme_repository.dart';

import 'package:provider/provider.dart';

import '../../auth/auth_repository.dart';
import '../../components/adaptive_gap.dart';
import '../../theme/colors.dart';
import '../../utils/constant.dart';
import '../../utils/size.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isOn = false;
  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    final auth = context.watch<AuthRepository>();
    final me = auth.me;
    String? avatar = me!.profilePic;
    if (!avatar.startsWith('http')) {
      avatar = '${UrlInfo.baseUrl}$avatar';
    }
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(
              horizontal: SizeConfig.getProportionateScreenWidth(24),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/Logo.svg',
                          width: SizeConfig.getProportionateScreenWidth(28),
                          height: SizeConfig.getProportionateScreenWidth(28),
                        ),
                        SizedBox(width: SizeConfig.getProportionateScreenWidth(10)),
                        Text(
                          'پروفایل',
                          style: TextStyle(
                            fontFamily: 'Peyda',
                            fontSize: SizeConfig.getProportionateFontSize(24),
                            fontWeight: FontWeight.w800,
                            color: isLightMode ? AppColors.grey900 : AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                      'assets/images/icons/MoreCircle.svg',
                      width: SizeConfig.getProportionateScreenWidth(28),
                      height: SizeConfig.getProportionateScreenWidth(28),
                      color: isLightMode ? AppColors.grey900 : AppColors.white,
                    ),
                  ],
                ),
                AdaptiveGap(SizeConfig.getProportionateScreenHeight(15)),
                SizedBox(
                  height: SizeConfig.getProportionateScreenHeight(189),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.network(
                        avatar,
                        width: SizeConfig.getProportionateScreenWidth(120),
                        height: SizeConfig.getProportionateScreenHeight(120),
                      ),
                      Text(
                        me.full_name,
                        style: TextStyle(
                          fontSize: SizeConfig.getProportionateFontSize(24),
                          color: isLightMode ? AppColors.grey900 : AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        me.phone_number,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: SizeConfig.getProportionateFontSize(14),
                          color: isLightMode ? AppColors.grey900 : AppColors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                AdaptiveGap(SizeConfig.getProportionateScreenHeight(15)),
                CustomListTile(
                  title: 'ویرایش پروفایل',
                  onTap: () {},
                  leadingIcon: 'assets/images/icons/Profile_curve.svg',
                  trailingIcon: 'assets/images/icons/ArrowCurve-Left2.svg',
                ),
                AdaptiveGap(SizeConfig.getProportionateScreenHeight(5)),
                CustomListTile(
                  title: 'آدرس',
                  onTap: () {},
                  leadingIcon: 'assets/images/icons/Location_curve.svg',
                  trailingIcon: 'assets/images/icons/ArrowCurve-Left2.svg',
                ),
                AdaptiveGap(SizeConfig.getProportionateScreenHeight(5)),
                CustomListTile(
                  title: 'اعلان',
                  onTap: () {},
                  leadingIcon: 'assets/images/icons/NotificationCurve.svg',
                  trailingIcon: 'assets/images/icons/ArrowCurve-Left2.svg',
                ),
                AdaptiveGap(SizeConfig.getProportionateScreenHeight(5)),
                CustomListTile(
                  title: 'پرداخت',
                  onTap: () {},
                  leadingIcon: 'assets/images/icons/WalletCurev.svg',
                  trailingIcon: 'assets/images/icons/ArrowCurve-Left2.svg',
                ),
                AdaptiveGap(SizeConfig.getProportionateScreenHeight(5)),
                CustomListTile(
                  title: 'امنیت',
                  onTap: () {},
                  leadingIcon: 'assets/images/icons/ShieldDoneCurve.svg',
                  trailingIcon: 'assets/images/icons/ArrowCurve-Left2.svg',
                ),
                AdaptiveGap(SizeConfig.getProportionateScreenHeight(5)),
                CustomListTile(
                  title: 'زبان',
                  onTap: () {},
                  leadingIcon: 'assets/images/icons/MoreCircleCurve.svg',
                  trailingIcon: 'assets/images/icons/ArrowCurve-Left2.svg',
                ),
                AdaptiveGap(SizeConfig.getProportionateScreenHeight(5)),
                CustomListTile(
                  title: 'تم تاریک',
                  onTap: () {},
                  leadingIcon: 'assets/images/icons/ShowCurve.svg',
                  trailing: AppToggle(
                    value: context.watch<ThemeRepository>().isDark,
                    onChanged: (v) => context.read<ThemeRepository>().setDark(v),
                  ),
                  isWidget: true,
                ),
                AdaptiveGap(SizeConfig.getProportionateScreenHeight(5)),
                CustomListTile(
                  title: 'حریم خصوصی',
                  onTap: () {},
                  leadingIcon: 'assets/images/icons/LockCurve.svg',
                  trailingIcon: 'assets/images/icons/ArrowCurve-Left2.svg',
                ),
                AdaptiveGap(SizeConfig.getProportionateScreenHeight(5)),
                CustomListTile(
                  title: 'کمک',
                  onTap: () {},
                  leadingIcon: 'assets/images/icons/InfoSquareCurve.svg',
                  trailingIcon: 'assets/images/icons/ArrowCurve-Left2.svg',
                ),
                AdaptiveGap(SizeConfig.getProportionateScreenHeight(5)),
                CustomListTile(
                  title: 'دعوت دوستان',
                  onTap: () {},
                  leadingIcon: 'assets/images/icons/3UserCurve.svg',
                  trailingIcon: 'assets/images/icons/ArrowCurve-Left2.svg',
                ),
                AdaptiveGap(SizeConfig.getProportionateScreenHeight(5)),
                CustomListTile(
                  title: 'خروج',
                  onTap: () {},
                  leadingIcon: 'assets/images/icons/LogoutCurve.svg',
                  isLogout: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.leadingIcon,
    this.trailingIcon,
    required this.title,
    required this.onTap,
    this.trailing,
    this.isWidget = false,
    this.isLogout = false,
  });

  final String leadingIcon;
  final String? trailingIcon;
  final Widget? trailing;
  final String title;
  final VoidCallback onTap;
  final bool? isWidget;
  final bool? isLogout;

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      title: Text(
        title,
        style: TextStyle(
          color: isLogout!
              ? AppColors.error
              : isLightMode
              ? AppColors.grey900
              : AppColors.white,
          fontSize: SizeConfig.getProportionateFontSize(14),
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: SvgPicture.asset(
        leadingIcon,
        color: isLogout!
            ? AppColors.error
            : isLightMode
            ? AppColors.grey900
            : AppColors.white,
        width: SizeConfig.getProportionateScreenWidth(24),
        height: SizeConfig.getProportionateScreenWidth(24),
      ),
      trailing: isWidget!
          ? trailing
          : trailingIcon != null
          ? SvgPicture.asset(
              trailingIcon!,
              color: isLightMode ? AppColors.grey900 : AppColors.white,
              width: SizeConfig.getProportionateScreenWidth(24),
              height: SizeConfig.getProportionateScreenWidth(24),
            )
          : null,
    );
  }
}

class AppToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double width;
  final double height;
  final Color activeColor;
  final Color inactiveColor;
  final Color knobColor;
  final Duration duration;

  const AppToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 54,
    this.height = 30,
    this.activeColor = AppColors.primary,
    this.inactiveColor = AppColors.grey200,
    this.knobColor = Colors.white,
    this.duration = const Duration(milliseconds: 180),
  });

  @override
  Widget build(BuildContext context) {
    final radius = height / 2;
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return Semantics(
      button: true,
      toggled: value,
      label: 'toggle',
      child: GestureDetector(
        onTap: () => onChanged(!value),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: duration,
          curve: Curves.easeOut,
          width: width,
          height: height,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isLightMode
                ? value
                      ? activeColor
                      : inactiveColor
                : value
                ? activeColor
                : AppColors.dark3,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: AnimatedAlign(
            duration: duration,
            curve: Curves.easeOut,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: height - 4,
              height: height - 4,
              decoration: BoxDecoration(
                color: knobColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
