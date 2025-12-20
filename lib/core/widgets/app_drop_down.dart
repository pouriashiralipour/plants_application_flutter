import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';

import '../utils/size_config.dart';
import 'gap.dart';
import 'app_alert_dialog.dart';

class AppDropDown extends StatefulWidget {
  const AppDropDown({
    super.key,
    required this.items,
    this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.dropdownMaxHeight,
    this.validator,
    this.showErrors = false,
  });

  final TextEditingController? controller;
  final double? dropdownMaxHeight;
  final String? hint;
  final List<String> items;
  final String? label;
  final ValueChanged<String>? onChanged;
  final bool showErrors;
  final FormFieldValidator<String>? validator;

  @override
  State<AppDropDown> createState() => _AppDropDownState();
}

class _AppDropDownState extends State<AppDropDown> with SingleTickerProviderStateMixin {
  late final AnimationController _ac;
  late final TextEditingController _controller;
  late final Animation<double> _fade;
  final GlobalKey _fieldKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  late final Animation<double> _scale;

  late FocusNode _focusNode;
  bool _hasText = false;
  bool _isFocused = false;
  bool _open = false;
  bool _ownController = false;
  bool _showAbove = false;

  OverlayEntry? _entry;
  MediaQueryData? _mq;
  OverlayState? _overlayState;

  @override
  void deactivate() {
    _removeOverlay(immediate: true, notify: false);
    super.deactivate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _overlayState ??= Overlay.of(context, rootOverlay: true);
    _mq ??= MediaQuery.of(context);
  }

  @override
  void dispose() {
    _removeOverlay(immediate: true, notify: false);
    _focusNode.dispose();
    _ac.dispose();
    if (_ownController) _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _ac = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));

    _fade = CurvedAnimation(parent: _ac, curve: Curves.easeOut);

    _scale = Tween(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ac, curve: Curves.easeOutCubic));

    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!mounted) return;
      setState(() => _isFocused = _focusNode.hasFocus);
    });

    if (widget.controller == null) {
      _controller = TextEditingController();
      _ownController = true;
    } else {
      _controller = widget.controller!;
    }
    _hasText = _controller.text.isNotEmpty;
  }

  bool get _isActive => _isFocused || _open;

  Color _iconColor({
    required bool isActive,
    required bool hasText,
    required bool isLightMode,
    required bool hasError,
  }) {
    if (hasError) return AppColors.error;
    if (isActive) return isLightMode ? AppColors.primary : AppColors.white;
    return hasText
        ? (isLightMode ? AppColors.grey900 : AppColors.white)
        : (isLightMode ? AppColors.grey500 : AppColors.grey600);
  }

  void _removeOverlay({bool immediate = false, bool notify = true}) {
    final entry = _entry;
    if (entry == null) return;

    _entry = null;
    _open = false;

    if (immediate) {
      _ac.stop();
    } else {
      _ac.reverse();
    }

    entry.remove();

    if (notify && mounted) {
      setState(() {});
    }
  }

  Color _resolveFillColor(bool isLightMode, {required bool hasError}) {
    if (hasError) return AppColors.error.withValues(alpha: 0.08);
    final focusColor = AppColors.primary.withValues(alpha: 0.08);
    if (_isActive) return focusColor;
    return isLightMode ? AppColors.grey50 : AppColors.dark2;
  }

  void _showOverlay(FormFieldState<String> field) {
    if (!mounted) return;
    if (_entry != null) return;

    final fieldCtx = _fieldKey.currentContext;
    if (fieldCtx == null) return;

    final ro = fieldCtx.findRenderObject();
    if (ro is! RenderBox || !ro.hasSize) return;

    final Size size = ro.size;
    final Offset pos = ro.localToGlobal(Offset.zero);

    final mq = _mq;
    if (mq == null) return;

    final screenH = mq.size.height;

    final desiredH = (widget.dropdownMaxHeight ?? 280) + 16;
    _showAbove = (screenH - (pos.dy + size.height)) < desiredH;

    _entry = OverlayEntry(
      builder: (overlayContext) {
        final isLightMode = Theme.of(overlayContext).brightness == Brightness.light;

        final scrimColor = isLightMode
            ? AppColors.white.withValues(alpha: 0.3)
            : AppColors.dark1.withValues(alpha: 0.3);

        final bg = isLightMode ? AppColors.white.withValues(alpha: 0.9) : AppColors.dark1;
        final border = isLightMode ? AppColors.grey900.withValues(alpha: 0.06) : AppColors.grey700;

        final List<BoxShadow> shadows = isLightMode
            ? [
                BoxShadow(
                  color: AppColors.grey900.withValues(alpha: 0.10),
                  blurRadius: 32,
                  offset: const Offset(0, 16),
                ),
                BoxShadow(
                  color: AppColors.grey900.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: AppColors.grey900.withValues(alpha: 0.55),
                  blurRadius: 40,
                  offset: const Offset(0, 24),
                ),
                BoxShadow(
                  color: AppColors.white.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 1),
                ),
              ];

        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _removeOverlay();
                  _focusNode.unfocus();
                },
                child: FadeTransition(
                  opacity: _fade,
                  child: Container(color: scrimColor),
                ),
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              targetAnchor: _showAbove ? Alignment.topRight : Alignment.bottomRight,
              followerAnchor: _showAbove ? Alignment.bottomRight : Alignment.topRight,
              offset: _showAbove ? const Offset(0, -8) : const Offset(0, 8),
              child: FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  alignment: _showAbove ? Alignment.bottomRight : Alignment.topRight,
                  child: Material(
                    color: Colors.transparent,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: size.width,
                          constraints: BoxConstraints(
                            maxHeight:
                                widget.dropdownMaxHeight ??
                                SizeConfig.getProportionateScreenWidth(280),
                          ),
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: border),
                            boxShadow: shadows,
                          ),
                          child: ListView.separated(
                            padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.getProportionateScreenHeight(8),
                            ),
                            shrinkWrap: true,
                            itemCount: widget.items.length,
                            separatorBuilder: (_, __) =>
                                Divider(height: 1, thickness: 0.5, color: border),
                            itemBuilder: (_, i) {
                              final text = widget.items[i];
                              final selected = _controller.text == text;
                              return InkWell(
                                onTap: () {
                                  _controller.text = text;
                                  setState(() => _hasText = text.isNotEmpty);
                                  widget.onChanged?.call(text);
                                  field.didChange(text);
                                  _removeOverlay();
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.getProportionateScreenWidth(12),
                                    vertical: SizeConfig.getProportionateScreenHeight(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          text,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontWeight: selected
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                            fontSize: SizeConfig.getProportionateScreenWidth(14),
                                          ),
                                        ),
                                      ),
                                      if (selected) const Icon(Icons.check_rounded, size: 20),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    final overlay = _overlayState;
    if (overlay == null) return;

    overlay.insert(_entry!);

    _open = true;
    if (mounted) setState(() {});
    _ac.forward(from: 0);
  }

  void _toggle(FormFieldState<String> field) =>
      _open ? _removeOverlay(immediate: false) : _showOverlay(field);

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;

    return FormField<String>(
      initialValue: _controller.text,
      autovalidateMode: widget.showErrors ? AutovalidateMode.always : AutovalidateMode.disabled,
      validator: (_) => widget.validator?.call(_controller.text.trim()),
      builder: (field) {
        final hasErrorNow = widget.showErrors && field.errorText != null;
        return CompositedTransformTarget(
          link: _layerLink,
          child: SizedBox(
            key: _fieldKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _controller,
                  readOnly: true,
                  focusNode: _focusNode,
                  onTap: () {
                    if (!_isFocused) _focusNode.requestFocus();
                    _toggle(field);
                  },
                  onChanged: (value) => setState(() => _hasText = value.isNotEmpty),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: isLightMode ? AppColors.grey900 : AppColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: SizeConfig.getProportionateFontSize(14),
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.getProportionateScreenWidth(16),
                      vertical: SizeConfig.getProportionateScreenHeight(18),
                    ),
                    labelText: widget.label,
                    hintText: widget.hint,
                    labelStyle: TextStyle(
                      color: isLightMode ? AppColors.grey500 : AppColors.grey600,
                      fontSize: SizeConfig.getProportionateFontSize(14),
                    ),
                    hintStyle: TextStyle(
                      color: isLightMode ? AppColors.grey500 : AppColors.grey600,
                      fontSize: SizeConfig.getProportionateFontSize(14),
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        if (!_isFocused) _focusNode.requestFocus();
                        _toggle(field);
                      },
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(end: 20),
                        child: AnimatedRotation(
                          turns: _open ? 0.5 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: SvgPicture.asset(
                            'assets/images/icons/Arrow-Down2_bold.svg',
                            width: SizeConfig.getProportionateScreenWidth(20),
                            height: SizeConfig.getProportionateScreenWidth(20),
                            color: _iconColor(
                              isActive: _isActive,
                              hasText: _hasText,
                              isLightMode: isLightMode,
                              hasError: hasErrorNow,
                            ),
                          ),
                        ),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: _resolveFillColor(isLightMode, hasError: hasErrorNow),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                ),
                Gap(SizeConfig.getProportionateScreenHeight(10)),
                if (hasErrorNow) AppAlertDialog(text: field.errorText!, isError: true),
              ],
            ),
          ),
        );
      },
    );
  }
}
