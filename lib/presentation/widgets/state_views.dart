import 'package:flutter/material.dart';

import '../../core/theme.dart';
import 'app_button.dart';

class StateViews {
  static Widget loading() {
    return Center(
      child: Semantics(
        label: 'Loading',
        child: const SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      ),
    );
  }

  static Widget error(String message, {VoidCallback? onRetry}) {
    final isOffline = message.toLowerCase().contains('offline');
    return _StatePanel(
      icon: isOffline ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
      iconColorBuilder: (context) => isOffline
          ? context.appColors.warning
          : Theme.of(context).colorScheme.error,
      title: isOffline ? 'No connection' : 'Something went wrong',
      message: message,
      actionLabel: onRetry != null ? 'Try again' : null,
      onAction: onRetry,
    );
  }

  static Widget empty(
    String title,
    String message, {
    IconData icon = Icons.inbox_outlined,
  }) {
    return _StatePanel(
      icon: icon,
      iconColorBuilder: (context) => Theme.of(context).colorScheme.primary,
      title: title,
      message: message,
    );
  }
}

class _StatePanel extends StatelessWidget {
  final IconData icon;
  final Color Function(BuildContext context) iconColorBuilder;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _StatePanel({
    required this.icon,
    required this.iconColorBuilder,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: iconColorBuilder(context).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(icon, color: iconColorBuilder(context), size: 34),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.appColors.mutedText),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: 180,
                child: AppButton(
                  label: actionLabel!,
                  icon: Icons.refresh_rounded,
                  onPressed: onAction,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
