import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/app_alert_dialog.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_progress_indicator.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/gap.dart';
import '../controllers/address_controller.dart';

class AddNewAddressScreen extends StatefulWidget {
  const AddNewAddressScreen({super.key});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final _addressCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _postalCtrl = TextEditingController();

  bool _isDefault = false;
  bool _showErrors = false;
  bool _submitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _postalCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _showErrors = true);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    final controller = context.read<AddressController>();

    final ok = await controller.add(
      name: _nameCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      postalCode: _postalCtrl.text.trim().isEmpty ? null : _postalCtrl.text.trim(),
      isDefault: _isDefault,
    );

    if (!mounted) return;
    setState(() => _submitting = false);

    if (ok) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    final controller = context.watch<AddressController>();

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add New Address'),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz))],
        ),
        body: Stack(
          children: [
            Positioned.fill(
              top: 0,
              bottom: SizeConfig.getProportionateScreenHeight(360),
              child: Container(
                color: isLightMode ? const Color(0xFFEAF7F1) : AppColors.dark2,
                child: Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.location_on, color: Colors.white, size: 34),
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProportionateScreenWidth(18),
                  vertical: SizeConfig.getProportionateScreenHeight(16),
                ),
                decoration: BoxDecoration(
                  color: isLightMode ? Colors.white : AppColors.dark1,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 28,
                      offset: const Offset(0, -8),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            width: 48,
                            height: 5,
                            decoration: BoxDecoration(
                              color: (isLightMode ? Colors.black : Colors.white).withValues(
                                alpha: 0.12,
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        Gap(SizeConfig.getProportionateScreenHeight(14)),
                        Text(
                          'Address Details',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: SizeConfig.getProportionateScreenWidth(22),
                            fontWeight: FontWeight.w800,
                            color: isLightMode ? AppColors.grey900 : AppColors.white,
                          ),
                        ),
                        Gap(SizeConfig.getProportionateScreenHeight(10)),
                        Divider(
                          color: (isLightMode ? AppColors.grey900 : AppColors.white).withValues(
                            alpha: 0.08,
                          ),
                        ),
                        if (controller.error != null) ...[
                          Gap(SizeConfig.getProportionateScreenHeight(10)),
                          AppAlertDialog(text: controller.error!, isError: true),
                        ],
                        Gap(SizeConfig.getProportionateScreenHeight(12)),

                        Text(
                          'Name Address',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: isLightMode ? AppColors.grey900 : AppColors.white,
                          ),
                        ),
                        Gap(SizeConfig.getProportionateScreenHeight(10)),
                        AppTextField(
                          isLightMode: isLightMode,
                          hintText: 'Apartment',
                          controller: _nameCtrl,
                          showErrors: _showErrors,
                          validator: (v) =>
                              (v == null || v.trim().isEmpty) ? 'نام آدرس را وارد کنید' : null,
                          textDirection: TextDirection.ltr,
                        ),

                        Gap(SizeConfig.getProportionateScreenHeight(14)),
                        Text(
                          'Address Details',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: isLightMode ? AppColors.grey900 : AppColors.white,
                          ),
                        ),
                        Gap(SizeConfig.getProportionateScreenHeight(10)),
                        AppTextField(
                          isLightMode: isLightMode,
                          hintText: '2899 Summer Drive Taylor, PC 48180',
                          controller: _addressCtrl,
                          showErrors: _showErrors,
                          validator: (v) =>
                              (v == null || v.trim().isEmpty) ? 'آدرس را وارد کنید' : null,
                          textDirection: TextDirection.ltr,
                          suffixIcon: 'assets/images/icons/Location_curve.svg',
                        ),

                        Gap(SizeConfig.getProportionateScreenHeight(14)),
                        Text(
                          'Postal Code (optional)',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: isLightMode ? AppColors.grey900 : AppColors.white,
                          ),
                        ),
                        Gap(SizeConfig.getProportionateScreenHeight(10)),
                        AppTextField(
                          isLightMode: isLightMode,
                          hintText: '48180',
                          controller: _postalCtrl,
                          showErrors: false,
                          textDirection: TextDirection.ltr,
                          keyboardType: TextInputType.number,
                        ),

                        Gap(SizeConfig.getProportionateScreenHeight(6)),
                        Row(
                          children: [
                            Checkbox(
                              value: _isDefault,
                              onChanged: (v) => setState(() => _isDefault = v ?? false),
                              activeColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            const Expanded(child: Text('Make this as the default address')),
                          ],
                        ),

                        Gap(SizeConfig.getProportionateScreenHeight(12)),
                        _submitting
                            ? const Center(child: AppProgressBarIndicator())
                            : AppButton(
                                onTap: _submit,
                                text: 'Add',
                                color: AppColors.primary,
                                width: SizeConfig.screenWidth,
                                fontSize: SizeConfig.getProportionateFontSize(16),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
