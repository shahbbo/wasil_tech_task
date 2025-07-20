import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../domain/entities/product.dart';
import '../bloc/product_cubit.dart';
import '../bloc/product_state.dart';
import '../widgets/product_list_widgets/category_chips.dart';
import '../widgets/product_list_widgets/error_view.dart';
import '../widgets/product_list_widgets/filter_bottom_sheet.dart';
import '../widgets/product_list_widgets/custom_app_bar.dart';
import 'package:flutter/services.dart';

import '../widgets/product_list_widgets/product_card.dart';
import '../widgets/product_list_widgets/custom_search_bar.dart';
import 'product_detail_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  double _absoluteMinPrice = 0;
  double _absoluteMaxPrice = 2000;

  double _currentMinPrice = 0;
  double _currentMaxPrice = 2000;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    context.read<ProductCubit>().loadProducts();
    context.read<CartCubit>().loadCartItems();
    _animationController.forward();
  }

  void _initializePriceRange(ProductLoaded state) {
    final allProducts = state.allProducts ?? state.products;

    if (allProducts.isNotEmpty) {
      final prices = allProducts.map((p) {
        return p.price * (1 - p.discountPercentage / 100);
      }).toList();

      final minPrice = prices.reduce((a, b) => a < b ? a : b);
      final maxPrice = prices.reduce((a, b) => a > b ? a : b);

      if (_absoluteMinPrice == 0 && _absoluteMaxPrice == 2000) {
        setState(() {
          _absoluteMinPrice = minPrice.floorToDouble();
          _absoluteMaxPrice = maxPrice.ceilToDouble();
          _currentMinPrice = _absoluteMinPrice;
          _currentMaxPrice = _absoluteMaxPrice;
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: AppStrings.products,
        cartItemCount: _getCartItemCount(),
        onCartTap: () => _navigateToCart(),
      ),
      body: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state is ProductError) {
            ToastHelper.showError(context, state.message);
          }
          if (state is ProductLoaded) {
            _initializePriceRange(state);
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Search Bar
              SliverToBoxAdapter(
                child: CustomSearchBar(
                  controller: _searchController,
                  onSearchChanged: (query) {
                    context.read<ProductCubit>().searchProducts(query);
                  },
                ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.3),
              ),

              // Category Chips
              if (state is ProductLoaded)
                SliverToBoxAdapter(
                  child: CategoryChips(
                    categories: state.categories,
                    selectedCategory: state.selectedCategory,
                    onCategorySelected: (category) {
                      context.read<ProductCubit>().filterByCategory(category);
                    },
                  ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.3),
                ),

              // Products Grid
              _buildProductContent(state),
            ],
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildProductContent(ProductState state) {
    if (state is ProductLoading || state is ProductInitial) {
      return _buildLoadingGrid();
    } else if (state is ProductLoaded) {
      return _buildProductGrid(state);
    } else if (state is ProductError) {
      return SliverToBoxAdapter(
        child: ErrorView(
          message: state.message,
          onRetry: () => context.read<ProductCubit>().loadProducts(),
        ).animate().fadeIn().shake(),
      );
    }
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }

  Widget _buildLoadingGrid() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => ProductCard.loading()
              .animate(delay: (index * 100).ms)
              .fadeIn()
              .slideY(begin: 0.3),
          childCount: 10,
        ),
      ),
    );
  }

  Widget _buildProductGrid(ProductLoaded state) {
    if (state.products.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 80,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No products found',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting your search or filters',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade500,
                    ),
              ),
            ],
          ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8)),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = state.products[index];
            return ProductCard(
              product: product,
              onTap: () => _navigateToProductDetail(product),
              onAddToCart: () => _addToCart(product),
            )
                .animate(delay: (index * 50).ms)
                .fadeIn()
                .slideY(begin: 0.2)
                .then()
                .shimmer(
                  delay: (2000 + index * 100).ms,
                  duration: 1000.ms,
                  color: Colors.white.withOpacity(0.1),
                );
          },
          childCount: state.products.length,
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoaded) {
          return FloatingActionButton.extended(
            onPressed: () => _showFilterBottomSheet(state),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.tune),
            label: const Text('Filter'),
          )
              .animate()
              .fadeIn(delay: 800.ms)
              .slideY(begin: 1)
              .then()
              .shimmer(delay: 3000.ms);
        }
        return const SizedBox.shrink();
      },
    );
  }

  int _getCartItemCount() {
    final cartState = context.watch<CartCubit>().state;
    if (cartState is CartLoaded) {
      return cartState.items.length;
    }
    return 0;
  }

  void _navigateToCart() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const CartPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
  }

  void _navigateToProductDetail(Product product) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProductDetailPage(product: product),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
      ),
    );
  }

  void _addToCart(Product product) {
    context.read<CartCubit>().addToCart(product, 1);
    ToastHelper.showSuccess(context, AppStrings.addedToCart);

    HapticFeedback.lightImpact();
  }

  void _showFilterBottomSheet(ProductLoaded state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FilterBottomSheet(
        categories: state.categories,
        selectedCategory: state.selectedCategory,
        minPrice: _absoluteMinPrice,
        maxPrice: _absoluteMaxPrice,
        currentMinPrice: state.minPrice ?? _currentMinPrice,
        currentMaxPrice: state.maxPrice ?? _currentMaxPrice,
        onPriceRangeSelected: (minPrice, maxPrice) {
          setState(() {
            _currentMinPrice = minPrice;
            _currentMaxPrice = maxPrice;
          });
          context.read<ProductCubit>().filterByPriceRange(minPrice, maxPrice);
        },
      ).animate().slideY(begin: 1).fadeIn(),
    );
  }
}
