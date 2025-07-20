import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CartHeader extends StatelessWidget {
  final int itemCount;

  const CartHeader({
    super.key,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Shopping Cart',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ).animate().slideY(begin: -0.5).fadeIn(),
                const SizedBox(height: 4),
                Text(
                  itemCount == 0
                      ? 'Your cart is empty'
                      : '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ).animate(delay: 200.ms).slideY(begin: -0.5).fadeIn(),
              ],
            ),
          ),

          // Cart Icon with Badge
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                if (itemCount > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red.shade400, Colors.red.shade600],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.4),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          itemCount > 99 ? '99+' : itemCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ).animate().scale(begin: const Offset(0, 0)).then().shake(),
                  ),
              ],
            ),
          ).animate(delay: 400.ms).scale(begin: const Offset(0, 0)),
        ],
      ),
    );
  }
}
