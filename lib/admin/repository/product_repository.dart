
import 'package:dio/dio.dart';

import 'package:shopora/model/product_model.dart';
import 'package:shopora/admin/services/product_service.dart';

class ProductRepository {
  final ProductServices productServices;

  ProductRepository(this.productServices);

  /// ✅ ADD PRODUCT
  Future<Map<String, dynamic>> addProduct(ProductModel product) async {
    try {
      final response = await productServices.addProduct(product);
      return _safeResponse(response.data);
    } on DioException catch (e) {
      throw Exception(_safeError(e));
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }

  // /// ✅ GET PRODUCTS (List return hoga is baar, Map nahi)
  // Future<List<dynamic>> getProducts() async {
  //   try {
  //     final response = await productServices.getProducts();
  //     final data = response.data;

  //     if (data is List)  return data;
     
  //     if (data is Map && data["products"] is List) return data["products"];
  //     return [];

  //   } on DioException catch (e) {
  //     throw Exception(_safeError(e));
  //   }
  // }

Future<List<dynamic>> getProducts() async {
  try {
    final response = await productServices.getProducts();
    final data = response.data;

    if (data is Map && data["data"] is List) {
      return List<dynamic>.from(data["data"]);
    }

    if (data is List) {
      return data;
    }

    return [];
  } on DioException catch (e) {
    throw Exception(_safeError(e));
  }
}
  /// ✅ UPDATE PRODUCT
  Future<Map<String, dynamic>> updateProduct(String id, ProductModel product) async {
    try {
      final response = await productServices.updateProduct(id, product);
      return _safeResponse(response.data);
    } on DioException catch (e) {
      throw Exception(_safeError(e));
    }
  }

  /// ✅ DELETE PRODUCT
  Future<Map<String, dynamic>> deleteProduct(String id) async {
    try {
      final response = await productServices.deleteProduct(id);
      return _safeResponse(response.data);
    } on DioException catch (e) {
      throw Exception(_safeError(e));
    }
  }

  // ───────────────────────────────────────────────────────
  // 🔒 SAME HELPER METHODS (copy-paste from auth_repository)
  // ───────────────────────────────────────────────────────
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

