import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../bloc/cart_cubit.dart';
import '../bloc/cart_state.dart';
import '../widgets/cart_header.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/cart_summary.dart';
import '../widgets/checkout_bottom_bar.dart';
import '../widgets/empty_cart.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _contentController;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scrollController.addListener(_onScroll);
    context.read<CartCubit>().loadCartItems();

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _contentController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _contentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final scrolled = _scrollController.offset > 10;
    if (scrolled != _isScrolled) {
      setState(() => _isScrolled = scrolled);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CartError) {
            ToastHelper.showError(context, state.message);
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildModernAppBar(state),
              _buildCartContent(state),
            ],
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoaded && state.items.isNotEmpty) {
            return CheckoutBottomBar(
              cartState: state,
              onCheckout: () => _handleCheckout(context, state),
            ).animate().slideY(begin: 1).fadeIn();
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildModernAppBar(CartState state) {
    int itemCount = 0;
    if (state is CartLoaded) {
      itemCount = state.items.fold(0, (sum, item) => sum + item.quantity);
    }

    return SliverAppBar(
      expandedHeight: 150,
      floating: false,
      pinned: true,
      elevation: _isScrolled ? 4 : 0,
      backgroundColor: _isScrolled ? Colors.white : Colors.transparent,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(_isScrolled ? 1 : 0.9),
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
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
          ),
        ),
      ).animate().slideX(begin: -1).fadeIn(),
      actions: [
        if (state is CartLoaded && state.items.isNotEmpty)
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(_isScrolled ? 1 : 0.9),
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
              onPressed: () => _showClearCartDialog(context),
              icon: const Icon(
                Icons.delete_outline,
                color: AppColors.error,
              ),
            ),
          ).animate().slideX(begin: 1).fadeIn(),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: CartHeader(
              itemCount: itemCount,
            ).animate().fadeIn().slideY(begin: -0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildCartContent(CartState state) {
    if (state is CartLoading || state is CartInitial) {
      return SliverFillRemaining(
        child: _buildLoadingView(),
      );
    } else if (state is CartLoaded) {
      if (state.items.isEmpty) {
        return SliverFillRemaining(
          child: const EmptyCart()
              .animate()
              .fadeIn()
              .scale(begin: const Offset(0.8, 0.8)),
        );
      }
      return _buildCartList(state);
    } else if (state is CartError) {
      return SliverFillRemaining(
        child: _buildErrorView(state.message),
      );
    }
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }

  Widget _buildLoadingView() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(
            3,
            (index) => Container(
                  margin: EdgeInsets.only(bottom: index == 2 ? 0 : 16),
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                )
                    .animate(delay: (index * 200).ms)
                    .fadeIn()
                    .slideY(begin: 0.3)
                    .then()
                    .shimmer(
                        duration: 1500.ms,
                        color: Colors.white.withOpacity(0.7))),
      ),
    );
  }

  Widget _buildCartList(CartLoaded state) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // Cart Summary Card
          CartSummary(
            itemsCount: state.items.length,
            totalItems: state.items.fold(0, (sum, item) => sum + item.quantity),
            subtotal: state.totalPrice,
            savings: _calculateSavings(state),
          ).animate().fadeIn().slideY(begin: 0.3),

          const SizedBox(height: 20),

          // Cart Items
          ...state.items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return Padding(
              padding: EdgeInsets.only(
                bottom: index == state.items.length - 1 ? 0 : 16,
              ),
              child: CartItemCard(
                item: item,
                onQuantityChanged: (quantity) {
                  context.read<CartCubit>().updateItemQuantity(
                        item.product.id,
                        quantity,
                      );
                  HapticFeedback.lightImpact();
                },
                onRemove: () => _removeItem(context, item.product.id),
              )
                  .animate(delay: (200 + index * 100).ms)
                  .fadeIn()
                  .slideX(begin: 0.3)
                  .then()
                  .shimmer(
                    delay: (1500 + index * 200).ms,
                    duration: 1000.ms,
                    color: Colors.white.withOpacity(0.1),
                  ),
            );
          }),
        ]),
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade50],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.error.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.error.withOpacity(0.1),
                    AppColors.error.withOpacity(0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<CartCubit>().loadCartItems(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh),
              label: const Text(AppStrings.retry),
            ),
          ],
        ),
      ).animate().fadeIn().shake(),
    );
  }

  double _calculateSavings(CartLoaded state) {
    return state.items.fold(0.0, (savings, item) {
      final originalPrice = item.product.price * item.quantity;
      final discountedPrice =
          originalPrice * (1 - item.product.discountPercentage / 100);
      return savings + (originalPrice - discountedPrice);
    });
  }

  void _removeItem(BuildContext context, int productId) {
    context.read<CartCubit>().removeFromCart(productId);
    ToastHelper.showInfo(context, AppStrings.removedFromCart);
    HapticFeedback.mediumImpact();
  }

  void _handleCheckout(BuildContext context, CartLoaded state) {
    HapticFeedback.heavyImpact();
    _showCheckoutDialog(context, state);
  }

  void _showCheckoutDialog(BuildContext context, CartLoaded state) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey.shade50],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Ready to Checkout?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.loginRequired,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: const Text(AppStrings.cancel),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const LoginPage(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1.0, 0.0),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeInOutCubic,
                                )),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(AppStrings.login),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).animate().scale(begin: const Offset(0.8, 0.8)).fadeIn(),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.warning_rounded,
                color: AppColors.error,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Clear Cart?'),
          ],
        ),
        content: const Text(
          'Are you sure you want to remove all items from your cart? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CartCubit>().clearCart();
              ToastHelper.showInfo(context, 'Cart cleared');
              HapticFeedback.heavyImpact();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ).animate().scale(begin: const Offset(0.8, 0.8)).fadeIn(),
    );
  }
}
