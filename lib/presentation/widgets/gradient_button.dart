import 'package:flutter/material.dart';
import 'app_button.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: text,
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }
}
