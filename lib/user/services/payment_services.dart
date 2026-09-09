
import 'package:dio/dio.dart';
import 'package:shopora/api_client.dart';
import 'package:shopora/utils/api_constants.dart';

class PaymentServices {
  /// ✅ USER - Create Payment
  Future<Response> createPayment({
    required String orderId,
    required String paymentMethod,
  }) async {
    final response = await dio.post(
      ApiConstants.paymentCreate,
      data: {"orderId": orderId, "paymentMethod": paymentMethod},
    );
    return response;
  }

  /// ✅ USER - Get My Payments
  Future<Response> getMyPayments() async {
    final response = await dio.get(ApiConstants.paymentGetAll);
    return response;
  }

  /// ✅ ADMIN - Get All Payments
  Future<Response> adminGetAllPayments() async {
    final response = await dio.get(ApiConstants.adminPaymentGetAll);
    return response;
  }

  /// ✅ ADMIN - Update Payment Status
  Future<Response> updatePaymentStatus({
    required String paymentId,
    required String paymentStatus,
  }) async {
    final response = await dio.patch(
      ApiConstants.adminPaymentUpdateStatus(paymentId),
      data: {"paymentStatus": paymentStatus},
    );
    return response;
  }

  /// ✅ ADMIN - Refund Payment
  Future<Response> refundPayment(String paymentId) async {
    final response = await dio.patch(
      ApiConstants.adminPaymentRefund(paymentId),
    );
    return response;
  }
}
