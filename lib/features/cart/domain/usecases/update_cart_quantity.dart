import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/cart_repository.dart';

class UpdateCartQuantity {
  final CartRepository repository;

  UpdateCartQuantity(this.repository);

  Future<Either<Failure, void>> call(int productId, int quantity) async {
    return await repository.updateQuantity(productId, quantity);
  }
}