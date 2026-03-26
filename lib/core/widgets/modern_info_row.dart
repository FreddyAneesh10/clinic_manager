import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ModernInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLongText;

  const ModernInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isLongText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: isLongText ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: AppColors.sidebarActive),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
