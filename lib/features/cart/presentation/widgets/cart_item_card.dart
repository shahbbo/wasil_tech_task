import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';

class CartItemCard extends StatefulWidget {
  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.item.product;
    final discountedPrice =
        product.price * (1 - product.discountPercentage / 100);
    final totalPrice = discountedPrice * widget.item.quantity;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
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
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Dismissible(
          key: Key(product.id.toString()),
          direction: DismissDirection.endToStart,
          background: _buildDismissBackground(),
          confirmDismiss: (direction) async {
            return await _showRemoveConfirmation();
          },
          onDismissed: (direction) => widget.onRemove(),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Product Image
                _buildProductImage(),

                const SizedBox(width: 16),

                // Product Info
                Expanded(
                  child:
                      _buildProductInfo(product, discountedPrice, totalPrice),
                ),

                // Actions Column
                _buildActionsColumn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Hero(
      tag: 'cart-product-${widget.item.product.id}',
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedNetworkImage(
            imageUrl: widget.item.product.thumbnail,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey.shade200,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey.shade200,
              child: Icon(
                Icons.image_not_supported,
                color: Colors.grey.shade400,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo(
      Product product, double discountedPrice, double totalPrice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Title
        Text(
          product.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 4),

        // Brand
        if (product.brand != null)
          Text(
            'By ${product.brand}',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),

        const SizedBox(height: 8),

        // Price Row
        Row(
          children: [
            Text(
              '\$${discountedPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            if (product.discountPercentage > 0) ...[
              const SizedBox(width: 8),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 4),

        // Total Price
        Text(
          'Total: \$${totalPrice.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(height: 8),

        // Quantity Controls
        _buildQuantityControls(),
      ],
    );
  }

  Widget _buildQuantityControls() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade100,
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuantityButton(
            icon: Icons.remove,
            onPressed: widget.item.quantity > 1
                ? () => widget.onQuantityChanged(widget.item.quantity - 1)
                : null,
          ),
          Container(
            width: 40,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              widget.item.quantity.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          _buildQuantityButton(
            icon: Icons.add,
            onPressed: widget.item.quantity < widget.item.product.stock
                ? () => widget.onQuantityChanged(widget.item.quantity + 1)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: onPressed != null
                ? AppColors.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: onPressed != null ? AppColors.primary : Colors.grey.shade400,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildActionsColumn() {
    return IconButton(
      onPressed: widget.onRemove,
      icon: Icon(
        Icons.delete_outline,
        color: AppColors.error,
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.error, Colors.red.shade700],
        ),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.delete_forever,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(height: 4),
          const Text(
            'Remove',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showRemoveConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Remove Item?'),
        content: Text(
          'Are you sure you want to remove "${widget.item.product.title}" from your cart?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Remove'),
          ),
        ],
      ).animate().scale(begin: const Offset(0.8, 0.8)).fadeIn(),
    );
  }
}
