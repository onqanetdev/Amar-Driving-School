import 'package:flutter/material.dart';

import '../common/convert_color.dart';

import 'package:flutter/material.dart';
import '../common/convert_color.dart';

class AppInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  final String? iconPath;
  final String? suffixIconPath;

  /// 🔥 NEW (custom widget support)
  final Widget? suffixWidget;

  /// HEX COLORS
  final String fillColor;
  final String borderColor;
  final String focusedBorderColor;
  final String hintColor;

  /// UI
  final double height;
  final double borderRadius;

  final double fontSize;
  final String fontFamily;

  /// Behavior
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int maxLength;
  final bool enabled;

  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  final bool readOnly;
  final VoidCallback? onTap;

  const AppInputField({
    super.key,
    required this.controller,
    required this.hintText,

    this.iconPath,
    this.suffixIconPath,

    /// 🔥 NEW
    this.suffixWidget,

    /// HEX defaults
    this.fillColor = "#F5F5F5",
    this.borderColor = "#B0B0B0",
    this.focusedBorderColor = "#002248",
    this.hintColor = "#232828",

    this.height = 45,
    this.borderRadius = 10,

    this.fontSize = 14,
    this.fontFamily = "InterRegular",

    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.maxLength = 50,
    this.enabled = true,

    this.onChanged,
    this.onSubmitted,

    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(
        color: HexColor(borderColor),
        width: 1,
      ),
    );

    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLength: maxLength,
          enabled: enabled,
          cursorColor: Colors.black,

          onChanged: onChanged,
          onSubmitted: onSubmitted,

          readOnly: readOnly,
          onTap: onTap,

          style: TextStyle(
            fontSize: fontSize,
            fontFamily: fontFamily,
            color: HexColor("#000000"),
          ),

          decoration: InputDecoration(
            counterText: '',
            hintText: hintText,

            hintStyle: TextStyle(
              fontSize: fontSize,
              fontFamily: fontFamily,
              color: HexColor(hintColor),
            ),

            filled: true,
            fillColor: HexColor(fillColor),

            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),

            /// 🔹 PREFIX ICON
            prefixIcon: iconPath != null
                ? Padding(
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                iconPath!,
                width: 18,
                height: 18,
                color: HexColor(borderColor),
              ),
            )
                : null,

            /// 🔹 SUFFIX ICON (UPDATED)
            suffixIcon: suffixWidget ??
                (suffixIconPath != null
                    ? Padding(
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    suffixIconPath!,
                    width: 18,
                    height: 18,
                    color: HexColor(borderColor),
                  ),
                )
                    : null),

            border: baseBorder,
            enabledBorder: baseBorder,
            focusedBorder: baseBorder.copyWith(
              borderSide: BorderSide(
                color: HexColor(focusedBorderColor),
                width: 1.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}