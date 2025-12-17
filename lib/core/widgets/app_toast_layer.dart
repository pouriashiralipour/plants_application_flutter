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

    final (bg, border, fg, icon) = _styleFor(message.type);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border),
              boxShadow: [
                BoxShadow(
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                  color: Colors.black.withValues(alpha: 0.12),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: fg, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message.text,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: fg,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: controller.dismiss,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(Icons.close, size: 18, color: fg.withValues(alpha: 0.75)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  (Color bg, Color border, Color fg, IconData icon) _styleFor(AppMessageType type) {
    switch (type) {
      case AppMessageType.success:
        return (
          AppColors.success.withValues(alpha: 0.34),
          AppColors.green.withValues(alpha: 0.65),
          AppColors.green,
          Icons.check_circle_outline,
        );
      case AppMessageType.error:
        return (
          AppColors.error.withValues(alpha: 0.34),
          AppColors.error.withValues(alpha: 0.65),
          AppColors.error,
          Icons.error_outline,
        );
      case AppMessageType.warning:
        return (
          AppColors.warning.withValues(alpha: 0.34),
          AppColors.orange.withValues(alpha: 0.65),
          AppColors.orange,
          Icons.warning_amber_outlined,
        );
      case AppMessageType.info:
        return (
          AppColors.primary.withValues(alpha: 0.10),
          AppColors.primary.withValues(alpha: 0.25),
          AppColors.primary,
          Icons.info_outline,
        );
    }
  }
}
