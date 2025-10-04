import 'package:flutter/material.dart';
import 'package:full_plants_ecommerce_app/screens/authentication/components/auth_scaffold.dart';

import '../../components/adaptive_gap.dart';
import '../../components/widgets/custom_text_field.dart';
import '../../components/widgets/cutsom_button.dart';
import '../../theme/colors.dart';
import '../../utils/size.dart';
import 'components/auth_svg_asset_widget.dart';
import 'components/custom_title_auth.dart';
import 'otp_scree.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  static String routeName = './forgot_password';

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    return AuthScaffold(
      appBar: AppBar(),
      header: AuthSvgAssetWidget(
        svg: isLightMode
            ? 'assets/images/Forgot_Password_Light_Frame.svg'
            : 'assets/images/Forgot_Password_Dark_Frame.svg',
      ),
      form: Column(
        children: [
          CustomTitleAuth(title: 'فراموشی رمز عبور'),
          AdaptiveGap(SizeConfig.getProportionateScreenHeight(40)),
          CustomTextField(
            isLightMode: isLightMode,
            preffixIcon: 'assets/images/icons/Message_bold.svg',
            hintText: 'ایمیل یا شماره تلفن',
          ),
        ],
      ),
      footer: CustomButton(
        text: 'ادامه',
        color: AppColors.primary,
        onTap: () {
          Navigator.pushNamed(context, OTPScreen.routeName);
        },
        width: SizeConfig.getProportionateScreenWidth(98),
      ),
    );
  }
}
