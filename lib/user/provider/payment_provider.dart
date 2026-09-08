
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shopora/auth/authprovider.dart'; // ✅ ApiState/ApiNotifier yahan se — apna sahi path
import 'package:shopora/model/payment_model.dart';
import 'package:shopora/user/services/payment_services.dart'; // apna sahi path
import 'package:shopora/user/repository/payment_repository.dart'; // apna sahi path

// 🔹 Service Provider
final paymentServicesProvider = Provider<PaymentServices>((ref) {
  return PaymentServices();
});

// 🔹 Repository Provider
final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final services = ref.watch(paymentServicesProvider);
  return PaymentRepository(services);
});

// 🔹 USER - Create Payment
final createPaymentProvider =
    StateNotifierProvider<ApiNotifier<Map<String, dynamic>>, ApiState<Map<String, dynamic>>>(
  (ref) => ApiNotifier<Map<String, dynamic>>(),
);

// 🔹 USER - My Payments List
final paymentListProvider =
    StateNotifierProvider<ApiNotifier<List<PaymentModel>>, ApiState<List<PaymentModel>>>(
  (ref) => ApiNotifier<List<PaymentModel>>(),
);

// 🔹 ADMIN - All Payments List
final adminPaymentListProvider =
    StateNotifierProvider<ApiNotifier<List<PaymentModel>>, ApiState<List<PaymentModel>>>(
  (ref) => ApiNotifier<List<PaymentModel>>(),
);

// 🔹 ADMIN - Update Payment Status
final updatePaymentStatusProvider =
    StateNotifierProvider<ApiNotifier<Map<String, dynamic>>, ApiState<Map<String, dynamic>>>(
  (ref) => ApiNotifier<Map<String, dynamic>>(),
);

// 🔹 ADMIN - Refund Payment
final refundPaymentProvider =
    StateNotifierProvider<ApiNotifier<Map<String, dynamic>>, ApiState<Map<String, dynamic>>>(
  (ref) => ApiNotifier<Map<String, dynamic>>(),
);