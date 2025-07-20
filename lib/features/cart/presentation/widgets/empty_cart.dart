import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_colors.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Empty Cart Animation Container
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.primary.withOpacity(0.05),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circles for animation
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
                // Cart Icon
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 80,
                  color: AppColors.primary.withOpacity(0.7),
                ),
              ],
            ),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.1, 1.1),
                duration: 2000.ms,
                curve: Curves.easeInOut,
              )
              .then()
              .shimmer(
                duration: 1500.ms,
                color: Colors.white.withOpacity(0.3),
              ),

          const SizedBox(height: 40),

          // Title
          Text(
            'Your Cart is Empty',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.3),

          const SizedBox(height: 16),

          // Subtitle
          Text(
            'Looks like you haven\'t added\nanything to your cart yet',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ).animate(delay: 700.ms).fadeIn().slideY(begin: 0.3),

          const SizedBox(height: 40),

          // Action Button
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              shadowColor: AppColors.primary.withOpacity(0.3),
            ),
            icon: const Icon(Icons.shopping_bag),
            label: const Text(
              'Start Shopping',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ).animate(delay: 900.ms).fadeIn().slideY(begin: 0.3).then().shimmer(
                delay: 2000.ms,
                duration: 1500.ms,
                color: Colors.white.withOpacity(0.3),
              ),

          const SizedBox(height: 24),

          // Suggestions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade50,
                  Colors.indigo.shade50,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.blue.shade200,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Colors.blue.shade600,
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  'Pro Tip',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Browse our latest products and find something amazing to add to your cart!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue.shade600,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ).animate(delay: 1100.ms).fadeIn().slideY(begin: 0.3),
        ],
      ),
    );
  }
}
