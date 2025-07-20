import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    int limit = 30,
    int skip = 0,
    String? category,
    String? sortBy,
    String? order,
  });

  Future<ProductModel> getProduct(int id);
  Future<List<String>> getCategories();
  Future<List<ProductModel>> searchProducts(String query);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<ProductModel>> getProducts({
    int limit = 30,
    int skip = 0,
    String? category,
    String? sortBy,
    String? order,
  }) async {
    try {
      String endpoint = ApiConstants.products;
      Map<String, dynamic> queryParams = {
        'limit': limit,
        'skip': skip,
      };

      if (category != null && category != 'All Categories') {
        endpoint = '${ApiConstants.products}/category/$category';
      }

      if (sortBy != null) {
        queryParams['sortBy'] = sortBy;
        queryParams['order'] = order ?? 'asc';
      }

      final response = await apiClient.get(
        endpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final products = (data['products'] as List)
            .map((product) => ProductModel.fromJson(product))
            .toList();
        return products;
      } else {
        throw ServerException('Failed to fetch products');
      }
    } catch (e) {
      if (e is ServerException || e is ConnectionException) {
        rethrow;
      }
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<ProductModel> getProduct(int id) async {
    try {
      final response = await apiClient.get('${ApiConstants.products}/$id');

      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to fetch product');
      }
    } catch (e) {
      if (e is ServerException || e is ConnectionException) {
        rethrow;
      }
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final response = await apiClient.get(ApiConstants.categories);

      if (response.statusCode == 200) {
        final categories = (response.data as List).map((category) {
          if (category is Map<String, dynamic>) {
            return category['name'] as String;
          } else {
            return category as String;
          }
        }).toList();
        return ['All Categories', ...categories];
      } else {
        throw ServerException('Failed to fetch categories');
      }
    } catch (e) {
      if (e is ServerException || e is ConnectionException) {
        rethrow;
      }
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.products}/search',
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final products = (data['products'] as List)
            .map((product) => ProductModel.fromJson(product))
            .toList();
        return products;
      } else {
        throw ServerException('Failed to search products');
      }
    } catch (e) {
      if (e is ServerException || e is ConnectionException) {
        rethrow;
      }
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }
}
