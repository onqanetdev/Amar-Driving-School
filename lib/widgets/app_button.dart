import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final IconData? icon;
  final String? assetIcon;

  final double height;
  final double borderRadius;
  final List<Color> gradientColors;
  final EdgeInsets padding;

  /// NEW: Text Style Control
  final TextStyle? textStyle;

  const AppButton({
    super.key,
    required this.text,
    this.onTap,
    this.icon,
    this.assetIcon,
    this.height = 45,
    this.borderRadius = 8,
    this.gradientColors = const [
      Color(0xFF3671E8),
      Color(0xFF033DAF),
    ],
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.textStyle,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {

  double scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => scale = 0.92); // 👈 more visible press
  }

  void _onTapCancel() {
    setState(() => scale = 1.0);
  }

  void _onTap() async {
    setState(() => scale = 0.92);

    await Future.delayed(const Duration(milliseconds: 80));

    setState(() => scale = 1.0);

    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // 👈 IMPORTANT
      onTapDown: _onTapDown,
      onTapCancel: _onTapCancel,
      onTap: _onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: scale,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 120),
          opacity: scale == 1.0 ? 1.0 : 0.85,
          child: Container(
            height: widget.height,
            padding: widget.padding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null)
                  Icon(widget.icon, color: Colors.white, size: 18),

                if (widget.assetIcon != null)
                  Image.asset(
                    widget.assetIcon!,
                    width: 18,
                    height: 18,
                    color: Colors.white,
                  ),

                if (widget.icon != null || widget.assetIcon != null)
                  const SizedBox(width: 8),

                Text(
                  widget.text,
                  style: widget.textStyle ??
                      const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: "InterBold",
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}