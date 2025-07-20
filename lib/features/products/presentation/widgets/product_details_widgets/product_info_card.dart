import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/product.dart';

class ProductInfoCard extends StatelessWidget {
  final Product product;

  const ProductInfoCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final discountedPrice =
        product.price * (1 - product.discountPercentage / 100);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
          ).animate().fadeIn().slideY(begin: 0.3),
          const SizedBox(height: 8),
          if (product.brand != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.primary.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'By ${product.brand}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ).animate(delay: 200.ms).fadeIn().slideX(begin: -0.3),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                '\$${discountedPrice.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
              const SizedBox(width: 12),
              if (product.discountPercentage > 0) ...[
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey.shade500,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.grey.shade500,
                        decorationThickness: 2,
                      ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.success, Colors.green.shade600],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Save \$${(product.price - discountedPrice).toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ).animate(delay: 400.ms).fadeIn().slideX(begin: -0.3),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildRatingSection(),
              const SizedBox(width: 24),
              _buildStockSection(),
            ],
          ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.3),
          const SizedBox(height: 16),
          _buildCategoryChip(),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.shade50,
            Colors.orange.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.amber.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            color: Colors.amber.shade600,
            size: 20,
          ),
          const SizedBox(width: 6),
          Text(
            product.rating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '(${product.reviews.length})',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockSection() {
    final isInStock = product.stock > 0;
    final isLowStock = product.stock > 0 && product.stock <= 10;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isInStock
              ? isLowStock
                  ? [Colors.orange.shade50, Colors.orange.shade100]
                  : [Colors.green.shade50, Colors.green.shade100]
              : [Colors.red.shade50, Colors.red.shade100],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isInStock
              ? isLowStock
                  ? Colors.orange.shade300
                  : Colors.green.shade300
              : Colors.red.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isInStock
                ? isLowStock
                    ? Icons.warning_rounded
                    : Icons.check_circle_rounded
                : Icons.cancel_rounded,
            color: isInStock
                ? isLowStock
                    ? Colors.orange.shade600
                    : Colors.green.shade600
                : Colors.red.shade600,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            isInStock
                ? isLowStock
                    ? '${product.stock} left'
                    : 'In Stock'
                : 'Out of Stock',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isInStock
                  ? isLowStock
                      ? Colors.orange.shade700
                      : Colors.green.shade700
                  : Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.secondary.withOpacity(0.1),
            AppColors.secondary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.secondary.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.category_rounded,
            size: 16,
            color: AppColors.secondary,
          ),
          const SizedBox(width: 8),
          Text(
            _formatCategoryName(product.category),
            style: const TextStyle(
              color: AppColors.secondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ).animate(delay: 800.ms).fadeIn().slideX(begin: -0.3);
  }

  String _formatCategoryName(String category) {
    return category
        .split('-')
        .map((word) => word.isEmpty
            ? ''
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ')
        .replaceAll('Mens', "Men's")
        .replaceAll('Womens', "Women's");
  }
}
