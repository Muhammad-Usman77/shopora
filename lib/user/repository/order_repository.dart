
import 'package:dio/dio.dart';
import 'package:shopora/model/order_model.dart';
import 'package:shopora/user/services/order_service.dart';


class OrderRepository {
  final OrderServices orderServices;

  OrderRepository(this.orderServices);

  Future<Map<String, dynamic>> createOrder({required String shippingAddress}) async {
    try {
      final response = await orderServices.createOrder(shippingAddress: shippingAddress);
      return _safeResponse(response.data);
    } on DioException catch (e) {
      throw Exception(_safeError(e));
    }
  }

  Future<List<OrderModel>> getAllOrders() async {
    try {
      final response = await orderServices.getAllOrders();
      final data = response.data;

      List<dynamic> rawList = [];
      if (data is Map && data['data'] is List) {
        rawList = data['data'];
      } else if (data is List) {
        rawList = data;
      }

      return rawList
          .map((item) => OrderModel.fromMap(item as Map<String, dynamic>))
          .toList();

    } on DioException catch (e) {
      throw Exception(_safeError(e));
    }
  }

  Future<Map<String, dynamic>> cancelOrder(String id) async {
    try {
      final response = await orderServices.cancelOrder(id);
      return _safeResponse(response.data);
    } on DioException catch (e) {
      throw Exception(_safeError(e));
    }
  }

  // ─────────────────────────────────────────────
  // 🔒 SAME HELPER METHODS
  // ─────────────────────────────────────────────
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

  
  Future<List<OrderModel>> adminGetAllOrders() async {
    try {
      final response = await orderServices.adminGetAllOrders();
      final data = response.data;

      List<dynamic> rawList = [];
      if (data is Map && data['data'] is List) {
        rawList = data['data'];
      } else if (data is List) {
        rawList = data;
      }

      return rawList
          .map((item) => OrderModel.fromMap(item as Map<String, dynamic>))
          .toList();

    } on DioException catch (e) {
      throw Exception(_safeError(e));
    }
  }

  Future<Map<String, dynamic>> adminUpdateStatus({
    required String orderId,
    required String status,
  }) async {
    try {
      final response = await orderServices.adminUpdateStatus(
        orderId: orderId,
        status: status,
      );
      return _safeResponse(response.data);
    } on DioException catch (e) {
      throw Exception(_safeError(e));
    }
  }
}


