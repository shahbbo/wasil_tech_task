import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../products/data/models/product_model.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<CartItem>>> getCartItems() async {
    try {
      final cartItems = await localDataSource.getCartItems();
      return Right(cartItems);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addToCart(Product product, int quantity) async {
    try {
      final cartItems = await localDataSource.getCartItems();
      final existingItemIndex = cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (existingItemIndex != -1) {
        // Update existing item quantity
        cartItems[existingItemIndex] = CartItemModel(
          product: cartItems[existingItemIndex].product,
          quantity: cartItems[existingItemIndex].quantity + quantity,
        );
      } else {
        // Add new item
        cartItems.add(CartItemModel(
          product: product is ProductModel 
              ? product 
              : ProductModel.fromJson({
                  'id': product.id,
                  'title': product.title,
                  'description': product.description,
                  'category': product.category,
                  'price': product.price,
                  'discountPercentage': product.discountPercentage,
                  'rating': product.rating,
                  'stock': product.stock,
                  'tags': product.tags,
                  'brand': product.brand,
                  'sku': product.sku,
                  'weight': product.weight,
                  'dimensions': {
                    'width': product.dimensions.width,
                    'height': product.dimensions.height,
                    'depth': product.dimensions.depth,
                  },
                  'warrantyInformation': product.warrantyInformation,
                  'shippingInformation': product.shippingInformation,
                  'availabilityStatus': product.availabilityStatus,
                  'reviews': product.reviews.map((review) => {
                    'rating': review.rating,
                    'comment': review.comment,
                    'date': review.date.toIso8601String(),
                    'reviewerName': review.reviewerName,
                    'reviewerEmail': review.reviewerEmail,
                  }).toList(),
                  'returnPolicy': product.returnPolicy,
                  'minimumOrderQuantity': product.minimumOrderQuantity,
                  'images': product.images,
                  'thumbnail': product.thumbnail,
                }),
          quantity: quantity,
        ));
      }

      await localDataSource.saveCartItems(cartItems);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(int productId) async {
    try {
      final cartItems = await localDataSource.getCartItems();
      cartItems.removeWhere((item) => item.product.id == productId);
      await localDataSource.saveCartItems(cartItems);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateQuantity(int productId, int quantity) async {
    try {
      final cartItems = await localDataSource.getCartItems();
      final itemIndex = cartItems.indexWhere(
        (item) => item.product.id == productId,
      );

      if (itemIndex != -1) {
        if (quantity <= 0) {
          cartItems.removeAt(itemIndex);
        } else {
          cartItems[itemIndex] = CartItemModel(
            product: cartItems[itemIndex].product,
            quantity: quantity,
          );
        }
        await localDataSource.saveCartItems(cartItems);
      }

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await localDataSource.clearCart();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}