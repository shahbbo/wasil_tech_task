import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../products/domain/entities/product.dart';
import '../repositories/cart_repository.dart';

class ClearCart {
  final CartRepository repository;

  ClearCart(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.clearCart();
  }
}
