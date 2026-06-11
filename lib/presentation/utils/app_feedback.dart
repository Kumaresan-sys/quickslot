import 'package:flutter/material.dart';

import '../../core/theme.dart';

class AppFeedback {
  const AppFeedback._();

  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message,
      icon: Icons.check_circle,
      backgroundColor: context.appColors.success,
    );
  }

  static void showError(BuildContext context, String message) {
    _show(
      context,
      message,
      icon: Icons.error_outline,
      backgroundColor: context.appColors.danger,
    );
  }

  static void showWarning(BuildContext context, String message) {
    _show(
      context,
      message,
      icon: Icons.info_outline,
      backgroundColor: context.appColors.warning,
      foregroundColor: Colors.black,
    );
  }

  static void _show(
    BuildContext context,
    String message, {
    required IconData icon,
    required Color backgroundColor,
    Color foregroundColor = Colors.white,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: backgroundColor,
          content: Row(
            children: [
              Icon(icon, color: foregroundColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: foregroundColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
