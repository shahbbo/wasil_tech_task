import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl(this.remoteDataSource, this.networkInfo);

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    int limit = 30,
    int skip = 0,
    String? category,
    String? sortBy,
    String? order,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getProducts(
          limit: limit,
          skip: skip,
          category: category,
          sortBy: sortBy,
          order: order,
        );
        return Right(products);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on ConnectionException catch (e) {
        return Left(ConnectionFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Product>> getProduct(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final product = await remoteDataSource.getProduct(id);
        return Right(product);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final categories = await remoteDataSource.getCategories();
        return Right(categories);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.searchProducts(query);
        return Right(products);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure('No internet connection'));
    }
  }
}