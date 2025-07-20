import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class GetCartItems {
  final CartRepository repository;

  GetCartItems(this.repository);

  Future<Either<Failure, List<CartItem>>> call() async {
    return await repository.getCartItems();
  }
}