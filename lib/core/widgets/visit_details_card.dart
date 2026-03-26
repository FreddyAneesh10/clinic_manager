import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'app_layout.dart';
import 'modern_info_row.dart';

class VisitDetailsCard extends StatelessWidget {
  final String time;
  final String reason;
  final bool isCompleted;

  const VisitDetailsCard({
    super.key,
    required this.time,
    required this.reason,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.event_note_outlined, color: AppColors.primary, size: 20),
              SizedBox(width: 12),
              Text(
                'VISIT INFORMATION',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.2,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1),
          ),
          ModernInfoRow(
            icon: Icons.access_time,
            label: 'Scheduled Time',
            value: time,
          ),
          const SizedBox(height: 20),
          ModernInfoRow(
            icon: Icons.medical_information_outlined,
            label: 'Reason for Visit',
            value: reason,
            isLongText: true,
          ),
        ],
      ),
    );
  }
}
