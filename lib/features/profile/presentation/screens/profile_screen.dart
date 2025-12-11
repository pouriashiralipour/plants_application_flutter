import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_repository.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/gap.dart';
import '../../../../core/widgets/app_progress_indicator.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../auth/data/repositories/auth_repository.dart';

import '../../../../core/config/app_constants.dart';
import '../../../../core/config/root_screen.dart';

class AppToggle extends StatelessWidget {
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

  final Color activeColor;
  final Duration duration;
  final double height;
  final Color inactiveColor;
  final Color knobColor;
  final ValueChanged<bool> onChanged;
  final bool value;
  final double width;

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

class CustomListTile extends StatefulWidget {
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

  final bool? isLogout;
  final bool? isWidget;
  final String leadingIcon;
  final VoidCallback onTap;
  final String title;
  final Widget? trailing;
  final String? trailingIcon;

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: widget.onTap,
      title: Text(
        widget.title,
        style: TextStyle(
          color: widget.isLogout!
              ? AppColors.error
              : isLightMode
              ? AppColors.grey900
              : AppColors.white,
          fontSize: SizeConfig.getProportionateFontSize(14),
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: SvgPicture.asset(
        widget.leadingIcon,
        color: widget.isLogout!
            ? AppColors.error
            : isLightMode
            ? AppColors.grey900
            : AppColors.white,
        width: SizeConfig.getProportionateScreenWidth(24),
        height: SizeConfig.getProportionateScreenWidth(24),
      ),
      trailing: widget.isWidget!
          ? widget.trailing
          : widget.trailingIcon != null
          ? SvgPicture.asset(
              widget.trailingIcon!,
              color: isLightMode ? AppColors.grey900 : AppColors.white,
              width: SizeConfig.getProportionateScreenWidth(24),
              height: SizeConfig.getProportionateScreenWidth(24),
            )
          : null,
    );
  }
}

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
    final me = context.watch<AuthRepository>().me;

    final avatarUrl = buildAvatarUrl(me?.profilePic);

    if (!auth.isAuthed || me == null) {
      return const Scaffold(
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.getProportionateScreenWidth(24)),
            child: Column(
              children: [
                Gap(SizeConfig.getProportionateScreenHeight(15)),
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
                Gap(SizeConfig.getProportionateScreenHeight(15)),
                SizedBox(
                  height: SizeConfig.getProportionateScreenHeight(189),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        key: ValueKey(auth.isAuthed),
                        radius: SizeConfig.getProportionateScreenWidth(50),
                        backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                        backgroundColor: isLightMode ? AppColors.grey200 : AppColors.dark3,
                        child: avatarUrl == null
                            ? Icon(
                                Icons.person,
                                color: isLightMode ? AppColors.grey600 : AppColors.grey100,
                                size: SizeConfig.getProportionateScreenWidth(40),
                              )
                            : null,
                      ),
                      Text(
                        me.fullName,
                        style: TextStyle(
                          fontSize: SizeConfig.getProportionateFontSize(24),
                          color: isLightMode ? AppColors.grey900 : AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        me.phoneNumber,
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
                Gap(SizeConfig.getProportionateScreenHeight(15)),
                CustomListTile(
                  title: 'ویرایش پروفایل',
                  onTap: () {},
                  leadingIcon: 'assets/images/icons/Profile_curve.svg',
                  trailingIcon: 'assets/images/icons/ArrowCurve-Left2.svg',
                ),
                Gap(SizeConfig.getProportionateScreenHeight(5)),
                CustomListTile(
                  title: 'آدرس',
                  onTap: () {},
                  leadingIcon: 'assets/images/icons/Location_curve.svg',
                  trailingIcon: 'assets/images/icons/ArrowCurve-Left2.svg',
                ),
                Gap(SizeConfig.getProportionateScreenHeight(5)),
                CustomListTile(
                  title: 'اعلان',
                  onTap: () {},
                  leadingIcon: 'assets/images/icons/NotificationCurve.svg',
                  trailingIcon: 'assets/images/icons/ArrowCurve-Left2.svg',
                ),
                Gap(SizeConfig.getProportionateScreenHeight(5)),
                CustomListTile(
                  title: 'پرداخت',
                  onTap: () {},
                  leadingIcon: 'assets/images/icons/WalletCurev.svg',
                  trailingIcon: 'assets/images/icons/ArrowCurve-Left2.svg',
                ),
                Gap(SizeConfig.getProportionateScreenHeight(5)),
                CustomListTile(
                  title: 'امنیت',
                  onTap: () {},
                  leadingIcon: 'assets/images/icons/ShieldDoneCurve.svg',
                  trailingIcon: 'assets/images/icons/ArrowCurve-Left2.svg',
                ),
                Gap(SizeConfig.getProportionateScreenHeight(5)),
                CustomListTile(
                  title: 'زبان',
                  onTap: () {},
                  leadingIcon: 'assets/images/icons/MoreCircleCurve.svg',
                  trailingIcon: 'assets/images/icons/ArrowCurve-Left2.svg',
                ),
                Gap(SizeConfig.getProportionateScreenHeight(5)),
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
                Gap(SizeConfig.getProportionateScreenHeight(5)),
                CustomListTile(
                  title: 'حریم خصوصی',
                  onTap: () {},
                  leadingIcon: 'assets/images/icons/LockCurve.svg',
                  trailingIcon: 'assets/images/icons/ArrowCurve-Left2.svg',
                ),
                Gap(SizeConfig.getProportionateScreenHeight(5)),
                CustomListTile(
                  title: 'کمک',
                  onTap: () {},
                  leadingIcon: 'assets/images/icons/InfoSquareCurve.svg',
                  trailingIcon: 'assets/images/icons/ArrowCurve-Left2.svg',
                ),
                Gap(SizeConfig.getProportionateScreenHeight(5)),
                CustomListTile(
                  title: 'دعوت دوستان',
                  onTap: () {},
                  leadingIcon: 'assets/images/icons/3UserCurve.svg',
                  trailingIcon: 'assets/images/icons/ArrowCurve-Left2.svg',
                ),
                Gap(SizeConfig.getProportionateScreenHeight(5)),
                CustomListTile(
                  title: 'خروج',
                  onTap: () async {
                    await showLogoutSheet(context);
                  },
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

Future<void> showLogoutSheet(BuildContext rootContext) {
  return showModalBottomSheet(
    context: rootContext,
    isScrollControlled: false,
    useSafeArea: true,
    isDismissible: true,
    backgroundColor: AppColors.white,
    barrierColor: AppColors.black.withOpacity(0.6), // ⬅️ withOpacity
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      bool isLoading = false;

      return StatefulBuilder(
        builder: (context, setModalState) {
          Future<void> _onConfirm() async {
            setModalState(() => isLoading = true);

            await Future.delayed(const Duration(seconds: 2));

            await rootContext.read<AuthRepository>().logout();

            if (Navigator.of(sheetContext).canPop()) {
              Navigator.of(sheetContext).pop();
            }

            Navigator.of(rootContext).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const RootScreen()),
              (route) => false,
            );
          }

          return Padding(
            padding: EdgeInsets.fromLTRB(
              SizeConfig.getProportionateScreenWidth(24),
              SizeConfig.getProportionateScreenHeight(8),
              SizeConfig.getProportionateScreenHeight(48),
              SizeConfig.getProportionateScreenWidth(24),
            ),
            child: SizedBox(
              height: SizeConfig.screenHeight * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: SizeConfig.getProportionateScreenWidth(38),
                    height: SizeConfig.getProportionateScreenHeight(3),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'خروج',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w800,
                      fontSize: SizeConfig.getProportionateFontSize(22),
                    ),
                  ),
                  const Spacer(),
                  const Divider(color: AppColors.grey200, height: 1),
                  const Spacer(),
                  Text(
                    'آیا می خواهید از برنامه خارج شوید ؟',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.grey800,
                      fontSize: SizeConfig.getProportionateFontSize(18),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(flex: 2),
                  Row(
                    children: [
                      Expanded(
                        child: isLoading
                            ? const AppProgressBarIndicator()
                            : AppButton(
                                onTap: _onConfirm,
                                text: 'بله',
                                color: AppColors.primary,
                                width: SizeConfig.getProportionateScreenWidth(184),
                                fontSize: SizeConfig.getProportionateFontSize(16),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppButton(
                          onTap: () {
                            Navigator.pop(rootContext);
                          },
                          text: 'خیر',
                          textColor: AppColors.primary,
                          color: AppColors.primary.withOpacity(0.1),
                          width: SizeConfig.getProportionateScreenWidth(184),
                          isShadow: false,
                          fontSize: SizeConfig.getProportionateFontSize(16),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          );
        },
      );
    },
  );
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
