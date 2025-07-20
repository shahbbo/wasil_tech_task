import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../products/domain/entities/product.dart';
import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItem>>> getCartItems();
  Future<Either<Failure, void>> addToCart(Product product, int quantity);
  Future<Either<Failure, void>> removeFromCart(int productId);
  Future<Either<Failure, void>> updateQuantity(int productId, int quantity);
  Future<Either<Failure, void>> clearCart();
}