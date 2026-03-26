import 'package:flutter/material.dart';
import 'responsive.dart';

class FormActionButton extends StatelessWidget {
  final bool isLoading;
  final String label;
  final VoidCallback onAction;
  const FormActionButton({super.key, required this.isLoading, required this.label, required this.onAction});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Align(
      alignment: isMobile ? Alignment.center : Alignment.centerRight,
      child: SizedBox(
        width: isMobile ? double.infinity : 200,
        height: 48,
        child: ElevatedButton(
          onPressed: isLoading ? null : onAction,
          child: isLoading 
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
            : Text(label),
        ),
      ),
    );
  }
}
