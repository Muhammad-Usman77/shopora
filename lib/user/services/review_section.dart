
import 'package:dio/dio.dart';
import 'package:shopora/api_client.dart';
import 'package:shopora/utils/api_constants.dart';

class ReviewServices {
  Future<Response> createReview({
    required String productId,
    required int rating,
    required String commentOne,
  }) async {
    final response = await dio.post(
      ApiConstants.reviewCreate,
      data: {"productId": productId, "rating": rating, "commentOne": commentOne},
    );
    return response;
  }

  Future<Response> getProductReviews(String productId) async {
    final response = await dio.get(ApiConstants.reviewByProduct(productId));
    return response;
  }

  Future<Response> deleteReview(String id) async {
    final response = await dio.delete(ApiConstants.reviewById(id));
    return response;
  }
}
