// ⚠️ URLs assume kiye hain based on index.js ("/cart" prefix)
// Apni cartRoutes.js check karke confirm/adjust kar lein
// ═══════════════════════════════════════════════════════════


import 'package:dio/dio.dart';
import 'package:shopora/api_client.dart';
import 'package:shopora/utils/api_constants.dart';

class CartServices {
  static const String baseUrl = "${ApiConstants.baseUrl}/cart";

  /// ✅ ADD TO CART
  Future<Response> addToCart({
    required String productId,
    required int quantity,
  }) async {
    final response = await dio.post(
      "$baseUrl/addToCart",
      data: {"productId": productId, "quantity": quantity},
    );
    return response;
  }

  /// ✅ GET CART
  Future<Response> getCart() async {
    final response = await dio.get("$baseUrl/getCart");
    return response;
  }

  /// ✅ UPDATE QUANTITY
  Future<Response> updateQuantity({
    required String cartId,
    required int quantity,
  }) async {
    final response = await dio.patch(
      "$baseUrl/update",
      data: {"cartId": cartId, "quantity": quantity},
    );
    return response;
  }

  /// ✅ REMOVE ONE (quantity -1 ya delete)
  Future<Response> removeFromCart(String cartId) async {
    final response = await dio.delete(
      "$baseUrl/remove",
      data: {"cartId": cartId},
    );
    return response;
  }

  /// ✅ CLEAR CART
  Future<Response> clearCart() async {
    final response = await dio.delete("$baseUrl/clear");
    return response;
  }
}

