

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shopora/auth/authprovider.dart';  // ApiState/ApiNotifier yahan se
import 'package:shopora/model/cart_model.dart';

import 'package:shopora/user/repository/cart_repository.dart';
import 'package:shopora/user/services/cart_servies.dart';


final cartServicesProvider = Provider<CartServices>((ref) {
  return CartServices();
});

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  final services = ref.watch(cartServicesProvider);
  return CartRepository(services);
});

// ✅ Add to Cart
final addToCartProvider =
    StateNotifierProvider<ApiNotifier<Map<String, dynamic>>, ApiState<Map<String, dynamic>>>(
  (ref) => ApiNotifier<Map<String, dynamic>>(),
);

// ✅ Get Cart List
final cartListProvider =
    StateNotifierProvider<ApiNotifier<List<CartItemModel>>, ApiState<List<CartItemModel>>>(
  (ref) => ApiNotifier<List<CartItemModel>>(),
);

// ✅ Update Quantity
final updateCartProvider =
    StateNotifierProvider<ApiNotifier<Map<String, dynamic>>, ApiState<Map<String, dynamic>>>(
  (ref) => ApiNotifier<Map<String, dynamic>>(),
);

// ✅ Remove From Cart
final removeCartProvider =
    StateNotifierProvider<ApiNotifier<Map<String, dynamic>>, ApiState<Map<String, dynamic>>>(
  (ref) => ApiNotifier<Map<String, dynamic>>(),
);
