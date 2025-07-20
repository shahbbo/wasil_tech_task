import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/cart_state.dart';

class CheckoutBottomBar extends StatefulWidget {
  final CartLoaded cartState;
  final VoidCallback onCheckout;

  const CheckoutBottomBar({
    super.key,
    required this.cartState,
    required this.onCheckout,
  });

  @override
  State<CheckoutBottomBar> createState() => _CheckoutBottomBarState();
}

class _CheckoutBottomBarState extends State<CheckoutBottomBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
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
    final shipping = widget.cartState.totalPrice > 50 ? 0.0 : 9.99;
    final total = widget.cartState.totalPrice + shipping;
    final itemCount =
        widget.cartState.items.fold(0, (sum, item) => sum + item.quantity);

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
        top: 20,
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
            offset: const Offset(0, -8),
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
          // Summary Row
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.primary.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$itemCount ${itemCount == 1 ? 'Item' : 'Items'}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Total Amount',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (shipping > 0)
                      Text(
                        '+ \$${shipping.toStringAsFixed(2)} shipping',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().slideY(begin: 0.3).fadeIn(),

          const SizedBox(height: 16),

          // Checkout Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final scale = 1.0 + (_pulseController.value * 0.02);
                return Transform.scale(
                  scale: scale,
                  child: ElevatedButton(
                    onPressed: () {
                      _startPulseAnimation();
                      widget.onCheckout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 8,
                      shadowColor: AppColors.primary.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shopping_bag,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Proceed to Checkout',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '\$${total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ).animate().slideY(begin: 1).fadeIn().then().shimmer(
                delay: 1500.ms,
                duration: 2000.ms,
                color: Colors.white.withOpacity(0.3),
              ),

          const SizedBox(height: 8),

          // Secure Checkout Info
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.security,
                size: 16,
                color: Colors.green.shade600,
              ),
              const SizedBox(width: 6),
              Text(
                'Secure & Safe Checkout',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ).animate(delay: 400.ms).fadeIn(),
        ],
      ),
    );
  }

  void _startPulseAnimation() {
    HapticFeedback.mediumImpact();
    _pulseController.forward().then((_) {
      _pulseController.reverse();
    });
  }
}
