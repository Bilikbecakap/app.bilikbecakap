import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class BilikButton extends StatelessWidget {
  const BilikButton._({
    required this.label,
    required this.onPressed,
    required this.isPrimary,
  });

  factory BilikButton.primary({
    required String label,
    required VoidCallback? onPressed,
  }) =>
      BilikButton._(label: label, onPressed: onPressed, isPrimary: true);

  factory BilikButton.secondary({
    required String label,
    required VoidCallback? onPressed,
  }) =>
      BilikButton._(label: label, onPressed: onPressed, isPrimary: false);

  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 0,
        ),
        child: Text(label, style: AppTextStyles.button),
      );
    }
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.navy,
        side: const BorderSide(color: AppColors.navy),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(label, style: AppTextStyles.button.copyWith(color: AppColors.navy)),
    );
  }
}
