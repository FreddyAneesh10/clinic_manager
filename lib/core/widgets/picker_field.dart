import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PickerField extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String value;
  final bool isEmpty;
  const PickerField({super.key, required this.onTap, required this.icon, required this.value, required this.isEmpty});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(prefixIcon: Icon(icon)),
        child: Text(value, style: TextStyle(color: isEmpty ? AppColors.textSecondary : AppColors.textPrimary)),
      ),
    );
  }
}
