// fancy_dropdown_form_field.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/colors.dart';
import '../../utils/size.dart';

class FancyDropdownFormField extends StatefulWidget {
  const FancyDropdownFormField({
    super.key,
    required this.items,
    this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.dropdownMaxHeight,
  });

  final TextEditingController? controller;
  final double? dropdownMaxHeight;
  final String? hint;
  final List<String> items;
  final String? label;
  final ValueChanged<String>? onChanged;

  @override
  State<FancyDropdownFormField> createState() => _FancyDropdownFormFieldState();
}

class _FancyDropdownFormFieldState extends State<FancyDropdownFormField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
  late final Animation<double> _fade = CurvedAnimation(parent: _ac, curve: Curves.easeOut);
  late final Animation<double> _scale = Tween(
    begin: 0.95,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _ac, curve: Curves.easeOutCubic));

  final GlobalKey _fieldKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();

  late final TextEditingController _controller;
  late FocusNode _focusNode;

  bool _hasText = false;
  bool _isFocused = false;
  bool _open = false;
  bool _ownController = false;
  bool _showAbove = false;

  OverlayEntry? _entry;

  bool get _isActive => _isFocused || _open;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() => _isFocused = _focusNode.hasFocus));

    if (widget.controller == null) {
      _controller = TextEditingController();
      _ownController = true;
    } else {
      _controller = widget.controller!;
    }
    _hasText = _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _removeOverlay();
    _ac.dispose();
    if (_ownController) _controller.dispose();
    super.dispose();
  }

  Color _resolveFillColor(bool isLightMode) {
    final focusColor = AppColors.primary.withValues(alpha: 0.08);
    if (_isActive) return focusColor;
    return isLightMode ? AppColors.grey50 : AppColors.dark2;
  }

  Color _iconColor({required bool isActive, required bool hasText, required bool isLightMode}) {
    if (isActive) return isLightMode ? AppColors.primary : AppColors.white;
    return hasText
        ? (isLightMode ? AppColors.grey900 : AppColors.white)
        : (isLightMode ? AppColors.grey500 : AppColors.grey600);
  }

  void _toggle() => _open ? _removeOverlay() : _showOverlay();

  void _showOverlay() {
    if (_entry != null) return;

    final box = _fieldKey.currentContext!.findRenderObject() as RenderBox;
    final Size size = box.size;
    final Offset pos = box.localToGlobal(Offset.zero);
    final screenH = MediaQuery.of(context).size.height;

    final desiredH = (widget.dropdownMaxHeight ?? 280) + 16;
    _showAbove = (screenH - (pos.dy + size.height)) < desiredH;

    _entry = OverlayEntry(
      builder: (context) {
        final isLightMode = Theme.of(context).brightness == Brightness.light;

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

    Overlay.of(context, rootOverlay: true).insert(_entry!);
    setState(() => _open = true);
    _ac.forward(from: 0);
  }

  void _removeOverlay() {
    if (_entry == null) return;
    _ac.reverse();
    _entry!.remove();
    _entry = null;
    setState(() => _open = false);
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;

    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        key: _fieldKey,
        child: TextFormField(
          controller: _controller,
          readOnly: true,
          focusNode: _focusNode,
          onTap: () {
            if (!_isFocused) _focusNode.requestFocus();
            _toggle();
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
              fontFamily: 'IranYekan',
            ),
            hintStyle: TextStyle(
              color: isLightMode ? AppColors.grey500 : AppColors.grey600,
              fontSize: SizeConfig.getProportionateFontSize(14),
              fontFamily: 'IranYekan',
            ),
            suffixIcon: InkWell(
              onTap: () {
                if (!_isFocused) _focusNode.requestFocus();
                _toggle();
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
            fillColor: _resolveFillColor(isLightMode),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}
