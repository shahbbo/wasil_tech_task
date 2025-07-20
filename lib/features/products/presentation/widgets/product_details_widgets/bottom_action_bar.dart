import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/product.dart';

class BottomActionBar extends StatefulWidget {
  final Product product;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const BottomActionBar({
    super.key,
    required this.product,
    required this.quantity,
    required this.onQuantityChanged,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  State<BottomActionBar> createState() => _BottomActionBarState();
}

class _BottomActionBarState extends State<BottomActionBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOutOfStock = widget.product.stock == 0;
    final discountedPrice =
        widget.product.price * (1 - widget.product.discountPercentage / 100);
    final totalPrice = discountedPrice * widget.quantity;

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
        top: 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Price & Quantity Row
          Row(
            children: [
              // Total Price
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Price',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    if (widget.product.discountPercentage > 0)
                      Text(
                        'Save \$${((widget.product.price - discountedPrice) * widget.quantity).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),

              // Quantity Selector
              if (!isOutOfStock) _buildQuantitySelector(),
            ],
          ),

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              // Add to Cart Button
              Expanded(
                flex: 2,
                child: _buildAddToCartButton(isOutOfStock),
              ),

              const SizedBox(width: 12),

              // Buy Now Button
              Expanded(
                flex: 3,
                child: _buildBuyNowButton(isOutOfStock),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade100,
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrease Button
          _buildQuantityButton(
            icon: Icons.remove,
            onPressed: widget.quantity > 1
                ? () {
                    widget.onQuantityChanged(widget.quantity - 1);
                    HapticFeedback.lightImpact();
                  }
                : null,
          ),

          // Quantity Display
          Container(
            width: 50,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              widget.quantity.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // Increase Button
          _buildQuantityButton(
            icon: Icons.add,
            onPressed: widget.quantity < widget.product.stock
                ? () {
                    widget.onQuantityChanged(widget.quantity + 1);
                    HapticFeedback.lightImpact();
                  }
                : null,
          ),
        ],
      ),
    ).animate().slideX(begin: 0.3).fadeIn();
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: onPressed != null
                ? AppColors.primary.withOpacity(0.1)
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: onPressed != null ? AppColors.primary : Colors.grey.shade400,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildAddToCartButton(bool isOutOfStock) {
    return ElevatedButton(
      onPressed: isOutOfStock ? null : widget.onAddToCart,
      style: ElevatedButton.styleFrom(
        backgroundColor: isOutOfStock ? Colors.grey.shade300 : Colors.white,
        foregroundColor:
            isOutOfStock ? Colors.grey.shade500 : AppColors.primary,
        elevation: 0,
        side: BorderSide(
          color: isOutOfStock ? Colors.grey.shade300 : AppColors.primary,
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isOutOfStock ? Icons.block : Icons.shopping_cart_outlined,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            isOutOfStock ? 'Out of Stock' : 'Add to Cart',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 1).fadeIn();
  }

  Widget _buildBuyNowButton(bool isOutOfStock) {
    return ElevatedButton(
      onPressed: isOutOfStock
          ? null
          : () {
              widget.onBuyNow();
              _startPulseAnimation();
            },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isOutOfStock ? Colors.grey.shade400 : AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: isOutOfStock
            ? Colors.transparent
            : AppColors.primary.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final scale = 1.0 + (_pulseController.value * 0.05);
          return Transform.scale(
            scale: scale,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isOutOfStock ? Icons.block : Icons.flash_on,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  isOutOfStock ? 'Unavailable' : 'Buy Now',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ).animate().slideY(begin: 1).fadeIn().then().shimmer(
          delay: 1000.ms,
          duration: 2000.ms,
          color: Colors.white.withOpacity(0.3),
        );
  }

  void _startPulseAnimation() {
    _pulseController.forward().then((_) {
      _pulseController.reverse();
    });
  }
}
