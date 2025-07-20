import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_product_categories.dart';
import '../../domain/usecases/get_products.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProducts getProducts;
  final GetProductCategories getCategories;

  ProductCubit({
    required this.getProducts,
    required this.getCategories,
  }) : super(ProductInitial());

  Future<void> loadProducts() async {
    emit(ProductLoading());

    final categoriesResult = await getCategories();
    final productsResult = await getProducts();

    categoriesResult.fold(
      (failure) => emit(ProductError(failure.toString())),
      (categories) async {
        productsResult.fold(
          (failure) => emit(ProductError(failure.toString())),
          (products) => emit(ProductLoaded(
            products: products,
            categories: categories,
            allProducts: products,
            categoryProducts: products,
          )),
        );
      },
    );
  }

  Future<void> filterByCategory(String category) async {
    final currentState = state;
    if (currentState is ProductLoaded) {
      emit(ProductLoading());

      final result = await getProducts(category: category);
      result.fold(
        (failure) => emit(ProductError(failure.toString())),
        (products) => emit(currentState.copyWith(
          products: products,
          categoryProducts: products,
          selectedCategory: category,
          searchQuery: null,
        )),
      );
    }
  }

  Future<void> sortProducts(String sortBy) async {
    final currentState = state;
    if (currentState is ProductLoaded) {
      emit(ProductLoading());

      final result = await getProducts(
        category: currentState.selectedCategory,
        sortBy: sortBy,
        order: 'asc',
      );

      result.fold(
        (failure) => emit(ProductError(failure.toString())),
        (products) => emit(currentState.copyWith(
          products: products,
          categoryProducts: products,
          sortBy: sortBy,
        )),
      );
    }
  }

  void searchProducts(String query) {
    final currentState = state;
    if (currentState is ProductLoaded) {
      if (query.isEmpty) {
        emit(currentState.copyWith(
          products: currentState.categoryProducts ?? currentState.products,
          searchQuery: null,
        ));
        return;
      }

      final productsToSearch =
          currentState.categoryProducts ?? currentState.products;
      final filteredProducts = productsToSearch.where((product) {
        return product.title.toLowerCase().contains(query.toLowerCase()) ||
            product.description.toLowerCase().contains(query.toLowerCase()) ||
            product.category.toLowerCase().contains(query.toLowerCase()) ||
            (product.brand?.toLowerCase().contains(query.toLowerCase()) ??
                false);
      }).toList();

      emit(currentState.copyWith(
        products: filteredProducts,
        searchQuery: query,
      ));
    }
  }

  void filterByPriceRange(double minPrice, double maxPrice) {
    final currentState = state;
    if (currentState is ProductLoaded) {
      final currentProducts = currentState.products;

      final filteredProducts = currentProducts.where((product) {
        final discountedPrice =
            product.price * (1 - product.discountPercentage / 100);
        return discountedPrice >= minPrice && discountedPrice <= maxPrice;
      }).toList();

      emit(currentState.copyWith(
        products: filteredProducts,
        minPrice: minPrice,
        maxPrice: maxPrice,
      ));
    }
  }
}
