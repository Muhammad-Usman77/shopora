
// ═══════════════════════════════════════════════════════════
// 📁 services/wishlist_services.dart
// ═══════════════════════════════════════════════════════════

import 'package:dio/dio.dart';
import 'package:shopora/api_client.dart';
import 'package:shopora/utils/api_constants.dart';

class WishlistServices {
  Future<Response> addToWishlist(String productId) async {
    final response = await dio.post(
      ApiConstants.wishlistAdd,
      data: {"productId": productId},
    );
    return response;
  }

  Future<Response> getMyWishlist() async {
    final response = await dio.get(ApiConstants.wishlistGetAll);
    return response;
  }

  Future<Response> removeFromWishlist(String productId) async {
    final response = await dio.delete(
      ApiConstants.wishlistRemove,
      data: {"productId": productId},
    );
    return response;
  }
}
