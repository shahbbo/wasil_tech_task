import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final List<String> categories;
  final String? selectedCategory;
  final String? sortBy;
  final List<Product>? allProducts;
  final List<Product>? categoryProducts;
  final double? minPrice;
  final double? maxPrice;
  final String? searchQuery;

  const ProductLoaded({
    required this.products,
    required this.categories,
    this.selectedCategory,
    this.sortBy,
    this.allProducts,
    this.categoryProducts,
    this.minPrice,
    this.maxPrice,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [
        products,
        categories,
        selectedCategory,
        sortBy,
        allProducts,
        categoryProducts,
        minPrice,
        maxPrice,
        searchQuery,
      ];

  ProductLoaded copyWith({
    List<Product>? products,
    List<String>? categories,
    String? selectedCategory,
    String? sortBy,
    List<Product>? allProducts,
    List<Product>? categoryProducts,
    double? minPrice,
    double? maxPrice,
    String? searchQuery,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      sortBy: sortBy ?? this.sortBy,
      allProducts: allProducts ?? this.allProducts,
      categoryProducts: categoryProducts ?? this.categoryProducts,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}

class ProductDetailLoading extends ProductState {}

class ProductDetailLoaded extends ProductState {
  final Product product;

  const ProductDetailLoaded(this.product);

  @override
  List<Object> get props => [product];
}
