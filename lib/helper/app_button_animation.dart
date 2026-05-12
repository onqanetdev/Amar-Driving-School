import 'package:flutter/material.dart';

class AppButtonAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const AppButtonAnimation({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  State<AppButtonAnimation> createState() => _AppButtonAnimationState();
}

class _AppButtonAnimationState extends State<AppButtonAnimation> {
  double scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => scale = 0.92); // 👈 more visible
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
      behavior: HitTestBehavior.opaque, // 👈 IMPORTANT FIX
      onTapDown: _onTapDown,
      onTapCancel: _onTapCancel,
      onTap: _onTap,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: scale == 1.0 ? 1.0 : 0.8,
          child: widget.child,
        ),
      ),
    );
  }
}