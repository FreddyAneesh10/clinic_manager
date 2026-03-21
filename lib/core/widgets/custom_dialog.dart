import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum DialogType { success, error, info }

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final DialogType type;
  final VoidCallback? onConfirm;

  const CustomDialog({
    super.key,
    required this.title,
    required this.message,
    this.type = DialogType.info,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (type) {
      case DialogType.success:
        icon = Icons.check_circle_outline;
        color = AppColors.completed;
        break;
      case DialogType.error:
        icon = Icons.error_outline;
        color = AppColors.error;
        break;
      case DialogType.info:
        icon = Icons.info_outline;
        color = AppColors.primary;
        break;
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 48),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: const TextStyle(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onConfirm != null) onConfirm!();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showAppDialog({
  required BuildContext context,
  required String title,
  required String message,
  DialogType type = DialogType.info,
  VoidCallback? onConfirm,
}) {
  return showDialog(
    context: context,
    builder: (context) => CustomDialog(
      title: title,
      message: message,
      type: type,
      onConfirm: onConfirm,
    ),
  );
}
