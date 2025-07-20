import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/product_repository.dart';

class GetProductCategories {
  final ProductRepository repository;

  GetProductCategories(this.repository);

  Future<Either<Failure, List<String>>> call() async {
    return await repository.getCategories();
  }
}