import 'package:flutter/material.dart';

import '../../../../core/utils/size.dart';



class AuthScaffold extends StatelessWidget {
  final Widget header;
  final Widget form;
  final Widget footer;
  final AppBar? appBar;

  const AuthScaffold({
    super.key,
    required this.header,
    required this.form,
    required this.footer,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = insets > 0;

    return Scaffold(
      appBar: appBar,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return AnimatedPadding(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(bottom: insets),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.getProportionateScreenWidth(24),
                          vertical: SizeConfig.getProportionateScreenHeight(24),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AnimatedScale(
                              scale: isKeyboardOpen ? 0.92 : 1.0,
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeOut,
                              child: header,
                            ),
                            Column(mainAxisSize: MainAxisSize.min, children: [form]),
                            SafeArea(
                              top: false,
                              minimum: const EdgeInsets.only(top: 12),
                              child: footer,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
