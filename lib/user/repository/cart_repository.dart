
import 'package:dio/dio.dart';
import 'package:shopora/model/cart_model.dart';
import 'package:shopora/user/services/cart_servies.dart';


class CartRepository {
  final CartServices cartServices;

  CartRepository(this.cartServices);

  Future<Map<String, dynamic>> addToCart({
    required String productId,
    required int quantity,
  }) async {
    try {
      final response = await cartServices.addToCart(
        productId: productId,
        quantity: quantity,
      );
      return _safeResponse(response.data);
    } on DioException catch (e) {
      throw Exception(_safeError(e));
    }
  }

  Future<List<CartItemModel>> getCart() async {
    try {
      final response = await cartServices.getCart();
      final data = response.data;

      List<dynamic> rawList = [];
      if (data is Map && data['data'] is List) {
        rawList = data['data'];
      } else if (data is List) {
        rawList = data;
      }

      return rawList
          .map((item) => CartItemModel.fromMap(item as Map<String, dynamic>))
          .toList();

    } on DioException catch (e) {
      throw Exception(_safeError(e));
    }
  }

  Future<Map<String, dynamic>> updateQuantity({
    required String cartId,
    required int quantity,
  }) async {
    try {
      final response = await cartServices.updateQuantity(
        cartId: cartId,
        quantity: quantity,
      );
      return _safeResponse(response.data);
    } on DioException catch (e) {
      throw Exception(_safeError(e));
    }
  }

  Future<Map<String, dynamic>> removeFromCart(String cartId) async {
    try {
      final response = await cartServices.removeFromCart(cartId);
      return _safeResponse(response.data);
    } on DioException catch (e) {
      throw Exception(_safeError(e));
    }
  }

  Future<Map<String, dynamic>> clearCart() async {
    try {
      final response = await cartServices.clearCart();
      return _safeResponse(response.data);
    } on DioException catch (e) {
      throw Exception(_safeError(e));
    }
  }

  // ─────────────────────────────────────────────
  // 🔒 SAME HELPER METHODS (copy-paste)
  // ─────────────────────────────────────────────
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
