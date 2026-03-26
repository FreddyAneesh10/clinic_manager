import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PatientHeader extends StatelessWidget {
  final String name, phone, reason;
  const PatientHeader({super.key, required this.name, required this.phone, required this.reason});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('$phone • Reason: $reason', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ],
        ),
      ),
    ]);
  }
}
