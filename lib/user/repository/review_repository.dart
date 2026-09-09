
import 'package:dio/dio.dart';
import 'package:shopora/model/review_model.dart';
import 'package:shopora/user/services/review_services.dart';


class ReviewRepository {
  final ReviewServices reviewServices;
  ReviewRepository(this.reviewServices);

  Future<Map<String, dynamic>> createReview({
    required String productId,
    required int rating,
    required String commentOne,
  }) async {
    try {
      final response = await reviewServices.createReview(
        productId: productId, rating: rating, commentOne: commentOne,
      );
      return _safeResponse(response.data);
    } on DioException catch (e) {
      throw Exception(_safeError(e));
    }
  }

  Future<List<ReviewModel>> getProductReviews(String productId) async {
    try {
      final response = await reviewServices.getProductReviews(productId);
      final data = response.data;
      List<dynamic> rawList = [];
      if (data is Map && data['data'] is List) rawList = data['data'];
      else if (data is List) rawList = data;
      return rawList.map((e) => ReviewModel.fromMap(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw Exception(_safeError(e));
    }
  }

  Future<Map<String, dynamic>> deleteReview(String id) async {
    try {
      final response = await reviewServices.deleteReview(id);
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
    if (errorData is Map && errorData["msg"] != null) return errorData["msg"].toString();
    if (errorData is String) return errorData;
    if (e.message != null) return e.message!;
    return "Something went wrong";
  }
}

