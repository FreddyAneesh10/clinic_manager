import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'app_layout.dart';

class PatientDetailsHeader extends StatelessWidget {
  final String patientId;
  final String name;
  final String phone;
  final String status;

  const PatientDetailsHeader({
    super.key,
    required this.patientId,
    required this.name,
    required this.phone,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.sidebar,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Hero(
            tag: 'patient_$patientId',
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.sidebarActive.withValues(alpha: 0.2),
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    StatusBadge(status: status),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone_outlined, color: AppColors.sidebarText, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      phone,
                      style: const TextStyle(color: AppColors.sidebarText, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
