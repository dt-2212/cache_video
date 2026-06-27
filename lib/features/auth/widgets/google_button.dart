import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Custom Google sign-in button with loading indicator state.
class GoogleButton extends StatelessWidget {
  final bool busy;
  final String label;
  final VoidCallback? onPressed;

  const GoogleButton({
    super.key,
    required this.busy,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      child: busy
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.g_mobiledata,
                    size: 28, color: AppColors.googleBlue),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
    );
  }
}
