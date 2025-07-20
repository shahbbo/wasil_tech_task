import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../domain/entities/product.dart';
import '../widgets/product_details_widgets/bottom_action_bar.dart';
import '../widgets/product_details_widgets/description_card.dart';
import '../widgets/product_details_widgets/image_carousel.dart';
import '../widgets/product_details_widgets/product_info_card.dart';
import '../widgets/product_details_widgets/reviews_section.dart';
import '../widgets/product_details_widgets/specifications_card.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _contentController;
  final ScrollController _scrollController = ScrollController();
  int _quantity = 1;
  bool _isFavorite = false;
  bool _showFloatingButton = false;

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scrollController.addListener(_onScroll);

    // Start animations
    _heroController.forward();
    Future.delayed(const Duration(milliseconds: 150), () {
      _contentController.forward();
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
    _contentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final showButton = _scrollController.offset > 200;
    if (showButton != _showFloatingButton) {
      setState(() => _showFloatingButton = showButton);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 60,
            floating: true,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: AppColors.textPrimary),
              ),
            ).animate().slideX(begin: -1).fadeIn(),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() => _isFavorite = !_isFavorite);
                    HapticFeedback.lightImpact();
                  },
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : AppColors.textPrimary,
                  ),
                ),
              ).animate().slideX(begin: 1).fadeIn(),
            ],
          ),
          SliverToBoxAdapter(
            child: ImageCarousel(
              images: widget.product.images,
              discountPercentage: widget.product.discountPercentage,
              stock: widget.product.stock,
            ).animate().fadeIn().slideY(begin: 0.3),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ProductInfoCard(
                  product: widget.product,
                ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.3),
                const SizedBox(height: 20),
                DescriptionCard(
                  description: widget.product.description,
                  tags: widget.product.tags,
                ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.3),
                const SizedBox(height: 20),
                SpecificationsCard(
                  product: widget.product,
                ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.3),
                const SizedBox(height: 20),
                ReviewsSection(
                  reviews: widget.product.reviews,
                  rating: widget.product.rating,
                ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.3),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        product: widget.product,
        quantity: _quantity,
        onQuantityChanged: (quantity) => setState(() => _quantity = quantity),
        onAddToCart: _addToCart,
        onBuyNow: _buyNow,
      ).animate().slideY(begin: 1).fadeIn(),
    );
  }

  void _addToCart() {
    if (widget.product.stock > 0) {
      context.read<CartCubit>().addToCart(widget.product, _quantity);
      ToastHelper.showSuccess(context, AppStrings.addedToCart);
      HapticFeedback.mediumImpact();
    } else {
      ToastHelper.showError(context, 'Product is out of stock');
    }
  }

  void _buyNow() {
    _addToCart();
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const CartPage()));
  }
}
