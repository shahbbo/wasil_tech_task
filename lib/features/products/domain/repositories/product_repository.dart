import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts({
    int limit = 30,
    int skip = 0,
    String? category,
    String? sortBy,
    String? order,
  });
  
  Future<Either<Failure, Product>> getProduct(int id);
  
  Future<Either<Failure, List<String>>> getCategories();
  
  Future<Either<Failure, List<Product>>> searchProducts(String query);
}