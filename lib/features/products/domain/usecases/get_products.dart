import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  Future<Either<Failure, List<Product>>> call({
    int limit = 30,
    int skip = 0,
    String? category,
    String? sortBy,
    String? order,
  }) async {
    return await repository.getProducts(
      limit: limit,
      skip: skip,
      category: category,
      sortBy: sortBy,
      order: order,
    );
  }
}