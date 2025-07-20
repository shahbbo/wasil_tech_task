import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/product.dart';

class SpecificationsCard extends StatelessWidget {
  final Product product;

  const SpecificationsCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
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
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  Icons.info_outline,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Specifications',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
            ],
          ).animate().slideX(begin: -0.3).fadeIn(),
          const SizedBox(height: 20),
          _buildSpecsGrid(),
        ],
      ),
    );
  }

  Widget _buildSpecsGrid() {
    final specs = _getProductSpecs();

    return Column(
      children: specs.asMap().entries.map((entry) {
        final index = entry.key;
        final spec = entry.value;

        return Container(
          margin: EdgeInsets.only(bottom: index == specs.length - 1 ? 0 : 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey.shade50,
                Colors.white,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: spec.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  spec.icon,
                  color: spec.color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spec.label,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      spec.value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate(delay: (index * 100).ms).fadeIn().slideX(begin: 0.3);
      }).toList(),
    );
  }

  List<ProductSpec> _getProductSpecs() {
    return [
      ProductSpec(
        label: 'SKU',
        value: product.sku,
        icon: Icons.qr_code_rounded,
        color: AppColors.primary,
      ),
      ProductSpec(
        label: 'Weight',
        value: '${product.weight}g',
        icon: Icons.scale_rounded,
        color: Colors.orange,
      ),
      ProductSpec(
        label: 'Dimensions',
        value:
            '${product.dimensions.width} × ${product.dimensions.height} × ${product.dimensions.depth} cm',
        icon: Icons.straighten_rounded,
        color: Colors.blue,
      ),
      ProductSpec(
        label: 'Warranty',
        value: product.warrantyInformation,
        icon: Icons.verified_user_rounded,
        color: Colors.green,
      ),
      ProductSpec(
        label: 'Shipping',
        value: product.shippingInformation,
        icon: Icons.local_shipping_rounded,
        color: Colors.purple,
      ),
      ProductSpec(
        label: 'Return Policy',
        value: product.returnPolicy,
        icon: Icons.assignment_return_rounded,
        color: Colors.teal,
      ),
      ProductSpec(
        label: 'Min Order',
        value:
            '${product.minimumOrderQuantity} ${product.minimumOrderQuantity == 1 ? 'unit' : 'units'}',
        icon: Icons.shopping_basket_rounded,
        color: Colors.red,
      ),
    ];
  }
}

class ProductSpec {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  ProductSpec({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}
