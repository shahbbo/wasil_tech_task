import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';

class CartSummary extends StatelessWidget {
  final int itemsCount;
  final int totalItems;
  final double subtotal;
  final double savings;

  const CartSummary({
    super.key,
    required this.itemsCount,
    required this.totalItems,
    required this.subtotal,
    required this.savings,
  });

  @override
  Widget build(BuildContext context) {
    final shipping = subtotal > 50 ? 0.0 : 9.99;
    final total = subtotal + shipping;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.receipt_long,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Order Summary',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
            ],
          ).animate().slideX(begin: -0.3).fadeIn(),

          const SizedBox(height: 20),

          // Summary Items
          _buildSummaryRow(
            'Items ($itemsCount products)',
            '\$${subtotal.toStringAsFixed(2)}',
            isSubtotal: true,
          ).animate(delay: 200.ms).fadeIn().slideX(begin: 0.3),

          if (savings > 0) ...[
            const SizedBox(height: 12),
            _buildSummaryRow(
              'Savings',
              '-\$${savings.toStringAsFixed(2)}',
              isDiscount: true,
            ).animate(delay: 400.ms).fadeIn().slideX(begin: 0.3),
          ],

          const SizedBox(height: 12),
          _buildSummaryRow(
            'Shipping',
            shipping == 0 ? 'FREE' : '\$${shipping.toStringAsFixed(2)}',
            isShipping: true,
            isFreeShipping: shipping == 0,
          ).animate(delay: 600.ms).fadeIn().slideX(begin: 0.3),

          if (subtotal <= 50 && shipping > 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.amber.shade50,
                    Colors.orange.shade50,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.amber.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.local_shipping,
                    color: Colors.amber.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Add \$${(50 - subtotal).toStringAsFixed(2)} more for FREE shipping!',
                      style: TextStyle(
                        color: Colors.amber.shade700,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate(delay: 800.ms).fadeIn().slideY(begin: 0.3),
          ],

          const SizedBox(height: 16),

          // Divider
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.grey.shade300,
                  Colors.transparent,
                ],
              ),
            ),
          ).animate(delay: 1000.ms).fadeIn(),

          const SizedBox(height: 16),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ).animate(delay: 1200.ms).fadeIn().slideY(begin: 0.3),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isSubtotal = false,
    bool isDiscount = false,
    bool isShipping = false,
    bool isFreeShipping = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            if (isFreeShipping)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.success, Colors.green.shade600],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'FREE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDiscount
                      ? AppColors.success
                      : isSubtotal
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
