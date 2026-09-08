
import 'package:dio/dio.dart';
import 'package:shopora/model/payment_model.dart';
import 'package:shopora/user/services/payment_services.dart'; // apna sahi path

class PaymentRepository {
  final PaymentServices paymentServices;

  PaymentRepository(this.paymentServices);

  /// ✅ USER - Create Payment
  Future<Map<String, dynamic>> createPayment({
    required String orderId,
    required String paymentMethod,
  }) async {
    try {
      final response = await paymentServices.createPayment(
        orderId: orderId,
        paymentMethod: paymentMethod,
      );
      return _safeResponse(response.data);
    } on DioException catch (e) {
      throw Exception(_safeError(e));
    }
  }

  /// ✅ USER - Get My Payments
  Future<List<PaymentModel>> getMyPayments() async {
    try {
      final response = await paymentServices.getMyPayments();
      return _parseList(response.data);
    } on DioException catch (e) {
      throw Exception(_safeError(e));
    }
  }

  /// ✅ ADMIN - Get All Payments
  Future<List<PaymentModel>> adminGetAllPayments() async {
    try {
      final response = await paymentServices.adminGetAllPayments();
      return _parseList(response.data);
    } on DioException catch (e) {
      throw Exception(_safeError(e));
    }
  }

  /// ✅ ADMIN - Update Payment Status
  Future<Map<String, dynamic>> updatePaymentStatus({
    required String paymentId,
    required String paymentStatus,
  }) async {
    try {
      final response = await paymentServices.updatePaymentStatus(
        paymentId: paymentId,
        paymentStatus: paymentStatus,
      );
      return _safeResponse(response.data);
    } on DioException catch (e) {
      throw Exception(_safeError(e));
    }
  }

  /// ✅ ADMIN - Refund Payment
  Future<Map<String, dynamic>> refundPayment(String paymentId) async {
    try {
      final response = await paymentServices.refundPayment(paymentId);
      return _safeResponse(response.data);
    } on DioException catch (e) {
      throw Exception(_safeError(e));
    }
  }

  // ─────────────────────────────────────────────
  // 🔒 SAME HELPER METHODS (har repository mein reuse)
  // ─────────────────────────────────────────────
  List<PaymentModel> _parseList(dynamic data) {
    List<dynamic> rawList = [];
    if (data is Map && data['data'] is List) {
      rawList = data['data'];
    } else if (data is List) {
      rawList = data;
    }
    return rawList
        .map((e) => PaymentModel.fromMap(e as Map<String, dynamic>))
        .toList();
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
