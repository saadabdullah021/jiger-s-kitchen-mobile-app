import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jigers_kitchen/utils/app_colors.dart';
import 'package:jigers_kitchen/utils/helper.dart';

import '../app_dimens.dart';
import '../app_text_styles.dart';

/// Shared text field.
///
/// All previously existing parameters are unchanged, so existing call sites
/// keep working. Focus/error/disabled styling comes from the app-wide
/// `inputDecorationTheme`; this widget adds the focus tint on the prefix icon
/// and the optional clear button.
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Color? fillColor;
  final List<TextInputFormatter>? formater;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool? readOnly;
  final VoidCallback? ontap;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final int? maxLines;

  /// Optional label rendered above the field.
  final String? label;

  /// When false the field is dimmed and not editable.
  final bool enabled;

  /// Shows a clear button while the field has text and is focused.
  final bool showClearButton;

  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;

  const CustomTextField({
    super.key,
    required this.controller,
    this.ontap,
    this.formater,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.fillColor,
    this.readOnly,
    this.maxLines,
    this.obscureText = false,
    this.textInputAction = TextInputAction.done,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.label,
    this.enabled = true,
    this.showClearButton = false,
    this.focusNode,
    this.onFieldSubmitted,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  FocusNode? _internalFocusNode;
  bool _focused = false;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChange);
  }

  void _onTextChange() {
    if (mounted && widget.showClearButton) setState(() {});
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _internalFocusNode)
          ?.removeListener(_onFocusChange);
      _focusNode.addListener(_onFocusChange);
      _focused = _focusNode.hasFocus;
    }
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onTextChange);
      widget.controller.addListener(_onTextChange);
    }
  }

  void _onFocusChange() {
    if (!mounted || _focused == _focusNode.hasFocus) return;
    setState(() => _focused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_onTextChange);
    // Only dispose the node this widget created.
    _internalFocusNode?.dispose();
    super.dispose();
  }

  Widget? _buildSuffix() {
    if (widget.suffixIcon != null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onSuffixIconTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(child: widget.suffixIcon),
        ),
      );
    }
    if (widget.showClearButton &&
        widget.enabled &&
        widget.readOnly != true &&
        _focused &&
        widget.controller.text.isNotEmpty) {
      return IconButton(
        tooltip: 'Clear text',
        icon: Icon(Icons.close_rounded,
            size: AppDimens.iconMd, color: AppColors.greyColor),
        onPressed: () {
          widget.controller.clear();
          widget.onChanged?.call('');
        },
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final field = TextFormField(
      validator: widget.validator ?? Helper.validateEmpty,
      readOnly: widget.readOnly == true ? true : false,
      enabled: widget.enabled,
      focusNode: _focusNode,
      controller: widget.controller,
      minLines: 1,
      maxLines: widget.obscureText ? 1 : (widget.maxLines ?? 1),
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      textInputAction: widget.textInputAction,
      style: AppTextStyles.body,
      cursorColor: AppColors.primaryColor,
      onChanged: (value) {
        widget.onChanged?.call(value);
      },
      onFieldSubmitted: widget.onFieldSubmitted,
      onTap: widget.ontap,
      inputFormatters: widget.formater ?? const [],
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.enabled
            ? (widget.fillColor ?? AppColors.lightGreyColor)
            : AppColors.dividerGreyColor,
        hintText: widget.hintText,
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.greyColor),
        prefixIcon: widget.prefixIcon == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(
                  left: AppDimens.md,
                  right: AppDimens.sm,
                ),
                child: SizedBox(
                  width: AppDimens.iconLg,
                  height: AppDimens.iconLg,
                  child: Center(child: widget.prefixIcon),
                ),
              ),
        suffixIcon: _buildSuffix(),
      ),
    );

    if (widget.label == null) return field;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppDimens.xs,
            bottom: AppDimens.sm,
          ),
          child: Text(widget.label!, style: AppTextStyles.secondary),
        ),
        field,
      ],
    );
  }
}
