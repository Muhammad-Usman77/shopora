
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shopora/auth/authprovider.dart'; // ApiState/ApiNotifier
import 'package:shopora/model/review_model.dart';
import 'package:shopora/user/services/review_services.dart';
import 'package:shopora/user/repository/review_repository.dart';

final reviewServicesProvider = Provider<ReviewServices>((ref) => ReviewServices());

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepository(ref.watch(reviewServicesProvider));
});

final createReviewProvider =
    StateNotifierProvider<ApiNotifier<Map<String, dynamic>>, ApiState<Map<String, dynamic>>>(
  (ref) => ApiNotifier<Map<String, dynamic>>(),
);

final productReviewsProvider =
    StateNotifierProvider<ApiNotifier<List<ReviewModel>>, ApiState<List<ReviewModel>>>(
  (ref) => ApiNotifier<List<ReviewModel>>(),
);


