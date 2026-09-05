
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shopora/auth/authprovider.dart';
import 'package:shopora/model/order_model.dart';
import 'package:shopora/user/repository/order_repository.dart';
import 'package:shopora/user/services/order_service.dart';


final orderServicesProvider = Provider<OrderServices>((ref) {
  return OrderServices();
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final services = ref.watch(orderServicesProvider);
  return OrderRepository(services);
});

// ✅ Create Order
final createOrderProvider =
    StateNotifierProvider<ApiNotifier<Map<String, dynamic>>, ApiState<Map<String, dynamic>>>(
  (ref) => ApiNotifier<Map<String, dynamic>>(),
);

// ✅ Get All Orders
final orderListProvider =
    StateNotifierProvider<ApiNotifier<List<OrderModel>>, ApiState<List<OrderModel>>>(
  (ref) => ApiNotifier<List<OrderModel>>(),
);

// ✅ Cancel Order
final cancelOrderProvider =
    StateNotifierProvider<ApiNotifier<Map<String, dynamic>>, ApiState<Map<String, dynamic>>>(
  (ref) => ApiNotifier<Map<String, dynamic>>(),
);

// ✅ Admin - Get All Orders
final adminOrderListProvider =
    StateNotifierProvider<ApiNotifier<List<OrderModel>>, ApiState<List<OrderModel>>>(
  (ref) => ApiNotifier<List<OrderModel>>(),
);

// ✅ Admin - Update Status
final adminUpdateStatusProvider =
    StateNotifierProvider<ApiNotifier<Map<String, dynamic>>, ApiState<Map<String, dynamic>>>(
  (ref) => ApiNotifier<Map<String, dynamic>>(),
);

