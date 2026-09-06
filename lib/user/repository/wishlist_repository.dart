
// ═══════════════════════════════════════════════════════════
// 📁 repository/wishlist_repository.dart
// ═══════════════════════════════════════════════════════════

import 'package:dio/dio.dart';
import 'package:shopora/model/whishlist_model.dart';
import 'package:shopora/user/services/wishlist_service.dart';

class WishlistRepository {
  final WishlistServices wishlistServices;

  WishlistRepository(this.wishlistServices);

  Future<Map<String, dynamic>> addToWishlist(String productId) async {
    try {
      final response = await wishlistServices.addToWishlist(productId);
      return _safeResponse(response.data);
    } on DioException catch (e) {
      throw Exception(_safeError(e));
    }
  }

  Future<List<WishlistItemModel>> getMyWishlist() async {
    try {
      final response = await wishlistServices.getMyWishlist();
      final data = response.data;

      List<dynamic> rawList = [];
      if (data is Map && data['data'] is List) {
        rawList = data['data'];
      } else if (data is List) {
        rawList = data;
      }

      return rawList
          .map((item) => WishlistItemModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(_safeError(e));
    }
  }

  Future<Map<String, dynamic>> removeFromWishlist(String productId) async {
    try {
      final response = await wishlistServices.removeFromWishlist(productId);
      return _safeResponse(response.data);
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
