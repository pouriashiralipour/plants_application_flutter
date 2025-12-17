import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_colors.dart';
import '../services/app_message_controller.dart';

class AppToastLayer extends StatelessWidget {
  const AppToastLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final msg = context.watch<AppMessageController>().current;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, anim) {
              final offset = Tween<Offset>(
                begin: const Offset(0, -0.25),
                end: Offset.zero,
              ).animate(anim);

              return SlideTransition(
                position: offset,
                child: FadeTransition(opacity: anim, child: child),
              );
            },
            child: msg == null
                ? const SizedBox.shrink()
                : _ToastCard(key: ValueKey(msg.id), message: msg),
          ),
        ),
      ),
    );
  }
}

class _ToastCard extends StatelessWidget {
  const _ToastCard({super.key, required this.message});

  final AppMessage message;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AppMessageController>();

    final style = _styleFor(message.type);
    final accent = style.accent;
    final fg = style.fg;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Material(
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [style.bgTop, style.bgBottom],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: style.border),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 22,
                      offset: const Offset(0, 12),
                      color: Colors.black.withValues(alpha: 0.14),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Accent strip (RTL-friendly: right side)
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      width: 4,
                      child: Container(color: accent.withValues(alpha: 0.9)),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon pill
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: accent.withValues(alpha: 0.28)),
                            ),
                            child: Icon(style.icon, color: accent, size: 20),
                          ),
                          const SizedBox(width: 10),

                          // Text
                          Expanded(
                            child: Text(
                              message.text,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: fg,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                height: 1.4,
                                letterSpacing: -0.1,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Close button
                          InkWell(
                            borderRadius: BorderRadius.circular(999),
                            onTap: controller.dismiss,
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: fg.withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Duration progress bar (visual only)
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 1.0, end: 0.0),
                          duration: message.duration,
                          builder: (context, value, _) {
                            return LinearProgressIndicator(
                              value: value,
                              minHeight: 3,
                              backgroundColor: Colors.white.withValues(alpha: 0.10),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                accent.withValues(alpha: 0.75),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _ToastStyle _styleFor(AppMessageType type) {
    switch (type) {
      case AppMessageType.success:
        return _ToastStyle(
          accent: AppColors.green,
          fg: AppColors.grey900,
          bgTop: AppColors.white.withValues(alpha: 0.92),
          bgBottom: AppColors.green.withValues(alpha: 0.08),
          border: AppColors.green.withValues(alpha: 0.22),
          icon: Icons.check_circle_outline,
        );
      case AppMessageType.error:
        return _ToastStyle(
          accent: AppColors.error,
          fg: AppColors.grey900,
          bgTop: AppColors.white.withValues(alpha: 0.92),
          bgBottom: AppColors.error.withValues(alpha: 0.07),
          border: AppColors.error.withValues(alpha: 0.22),
          icon: Icons.error_outline,
        );
      case AppMessageType.warning:
        return _ToastStyle(
          accent: AppColors.orange,
          fg: AppColors.grey900,
          bgTop: AppColors.white.withValues(alpha: 0.92),
          bgBottom: AppColors.orange.withValues(alpha: 0.08),
          border: AppColors.orange.withValues(alpha: 0.22),
          icon: Icons.warning_amber_outlined,
        );
      case AppMessageType.info:
        return _ToastStyle(
          accent: AppColors.primary,
          fg: AppColors.grey900,
          bgTop: AppColors.white.withValues(alpha: 0.92),
          bgBottom: AppColors.primary.withValues(alpha: 0.07),
          border: AppColors.primary.withValues(alpha: 0.20),
          icon: Icons.info_outline,
        );
    }
  }
}

class _ToastStyle {
  const _ToastStyle({
    required this.accent,
    required this.fg,
    required this.bgTop,
    required this.bgBottom,
    required this.border,
    required this.icon,
  });

  final Color accent;
  final Color fg;
  final Color bgTop;
  final Color bgBottom;
  final Color border;
  final IconData icon;
}
