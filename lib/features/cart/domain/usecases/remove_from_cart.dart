import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/cart_repository.dart';

class RemoveFromCart {
  final CartRepository repository;

  RemoveFromCart(this.repository);

  Future<Either<Failure, void>> call(int productId) async {
    return await repository.removeFromCart(productId);
  }
}