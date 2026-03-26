import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class QueuedItemData {
  final String title;
  final String subtitle;
  QueuedItemData({required this.title, required this.subtitle});
}

class QueuedSection extends StatelessWidget {
  final List<QueuedItemData> items;
  final ValueChanged<int> onRemove;
  const QueuedSection({super.key, required this.items, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.background.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('QUEUED (${items.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          ...items.asMap().entries.map((e) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
                  child: const Icon(Icons.medical_services_outlined, size: 16, color: AppColors.textSecondary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.value.title.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(e.value.subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(onPressed: () => onRemove(e.key), icon: const Icon(Icons.close, size: 18, color: AppColors.textSecondary)),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
