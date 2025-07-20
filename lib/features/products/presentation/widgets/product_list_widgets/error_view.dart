import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/constants/app_colors.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Error Icon with Animation
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.red.shade400,
                  Colors.red.shade600,
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.error_outline,
              size: 50,
              color: Colors.white,
            ),
          )
              .animate()
              .scale(begin: const Offset(0, 0), curve: Curves.elasticOut)
              .then()
              .shake(hz: 2),

          const SizedBox(height: 32),

          // Error Title
          Text(
            'Oops! Something went wrong',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
            textAlign: TextAlign.center,
          ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.3),

          const SizedBox(height: 16),

          // Error Message
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.red.shade200,
                width: 1,
              ),
            ),
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.red.shade700,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
          ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.3),

          const SizedBox(height: 32),

          // Retry Button
          ElevatedButton.icon(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              shadowColor: AppColors.primary.withOpacity(0.4),
            ),
            icon: const Icon(Icons.refresh),
            label: const Text(
              'Try Again',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
              .animate(delay: 600.ms)
              .fadeIn()
              .slideY(begin: 0.3)
              .then()
              .shimmer(delay: 2000.ms, color: Colors.white.withOpacity(0.3)),

          const SizedBox(height: 16),

          // Help Text
          Text(
            'Please check your connection and try again',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade500,
                ),
            textAlign: TextAlign.center,
          ).animate(delay: 800.ms).fadeIn(),
        ],
      ),
    );
  }
}
