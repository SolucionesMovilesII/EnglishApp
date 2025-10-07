import 'package:flutter/material.dart';

class NoLivesDialog extends StatelessWidget {
  final String? nextReset;
  final VoidCallback? onDismiss;

  const NoLivesDialog({
    super.key,
    this.nextReset,
    this.onDismiss,
  });

  static Future<void> show(
    BuildContext context, {
    String? nextReset,
    VoidCallback? onDismiss,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => NoLivesDialog(
        nextReset: nextReset,
        onDismiss: onDismiss,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Column(
        children: [
          Icon(
            Icons.favorite_border,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 12),
          Text(
            'Out of Lives!',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "You've used all your lives for today. Take a break and come back tomorrow for a fresh start!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Lives visualization
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) => 
              Padding(
                padding: EdgeInsets.only(right: index < 4 ? 4 : 0),
                child: Icon(
                  Icons.favorite_border,
                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.5),
                  size: 24,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Reset time info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.schedule,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                const SizedBox(height: 4),
                Text(
                  'Lives Reset',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Tomorrow at 1:00 AM',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Encouraging message
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Use this time to review what you\'ve learned!',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onDismiss?.call();
          },
          child: const Text('I Understand'),
        ),
      ],
    );
  }
}

/// Extension method to easily show the no lives dialog from any provider or widget
extension NoLivesDialogExtension on BuildContext {
  Future<void> showNoLivesDialog({
    String? nextReset,
    VoidCallback? onDismiss,
  }) {
    return NoLivesDialog.show(
      this,
      nextReset: nextReset,
      onDismiss: onDismiss,
    );
  }
}