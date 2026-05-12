import 'package:flutter/material.dart';

import '../common/app_color.dart';
import '../common/convert_color.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? icon;
  final bool obscure;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.icon,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return
      TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: HexColor(AppColor.colorInputBg),

        prefixIcon: icon != null
            ? Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset(icon!, width: 18),
        )
            : null,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}