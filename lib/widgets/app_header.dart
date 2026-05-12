import 'package:flutter/material.dart';

import '../helper/app_button_animation.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final bool showBack;
  final bool showAddButton;
  final String? addButtonText;
  final IconData? addIcon;
  final bool showAddIcon;
  final VoidCallback? onBack;
  final VoidCallback? onAdd;

  const AppHeader({
    super.key,
    required this.title,
    this.showBack = false,
    this.showAddButton = false,
    this.addButtonText,
    this.addIcon,
    this.showAddIcon = true,
    this.onBack,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.fromLTRB(10, 35, 10, 0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 1, 70, 148),
            Color.fromARGB(255, 1, 9, 20)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [

          /// BACK BUTTON
          if (showBack)
            GestureDetector(
              onTap: onBack ?? () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),

          if (showBack) const SizedBox(width: 10),

          /// TITLE
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'InterBold',
            ),
          ),

          const Spacer(),

          /// ADD BUTTON
          if (showAddButton)
            AppButtonAnimation(
              onTap: onAdd,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    if (showAddIcon && addIcon != null) ...[
                      Icon(
                        addIcon!,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(addButtonText ?? "Add",
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}