import 'package:dio/dio.dart';
import 'package:shopora/user/services/services.dart';

class ProductRepository {
  final ProductServices productServices;

  ProductRepository(this.productServices);

  Future<List<dynamic>> getAllProducts() async {
    try {
      final response = await productServices.getProducts();
      final data = response.data;
      if (data is Map && data['data'] is List) {
        return List<dynamic>.from(data['data']);
      }
      if (data is List) {
        return data;
      }
      return [];
    } on DioException catch (e) {
      throw Exception(_safeError(e));
    }
  }
  Map<String, dynamic> _safeResponse(dynamic data) {
  if (data is Map<String, dynamic>) return data;
  if (data is Map) return Map<String, dynamic>.from(data);
  if (data is String) return {"message": data};
  if (data is List) return {"data": data};
  return {"message": "Unexpected response format"};
}

String _safeError(DioException e) {
  final errorData = e.response?.data;
  if (errorData is Map && errorData["msg"] != null) {
    return errorData["msg"].toString();
  } else if (errorData is String) {
    return errorData;
  } else if (e.message != null) {
    return e.message!;
  }
  return "Something went wrong";
}

}

// ───────────────────────────────────────────────────────
// 🔒 SAME HELPER METHODS (copy-paste from auth_repository)
// ───────────────────────────────────────────────────────
