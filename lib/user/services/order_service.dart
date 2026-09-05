// ═══════════════════════════════════════════════════════════
// 📁 STEP 2: services/order_services.dart
// ═══════════════════════════════════════════════════════════


import 'package:dio/dio.dart';
import 'package:shopora/api_client.dart';
import 'package:shopora/utils/api_constants.dart';

class OrderServices {

  /// ✅ CREATE ORDER
  Future<Response> createOrder({required String shippingAddress}) async {
    final response = await dio.post(
      ApiConstants.orderCreate,
      data: {"shippingAddress": shippingAddress},
    );
    return response;
  }

  /// ✅ GET ALL ORDERS
  Future<Response> getAllOrders() async {
    final response = await dio.get(ApiConstants.orderGetAll);
    return response;
  }

  /// ✅ GET ORDER BY ID
  Future<Response> getOrderById(String id) async {
    final response = await dio.get(ApiConstants.orderById(id));
    return response;
  }

  /// ✅ CANCEL ORDER
  Future<Response> cancelOrder(String id) async {
    final response = await dio.patch(ApiConstants.orderCancel(id));
    return response;
  }

   /// ✅ ADMIN - GET ALL ORDERS (sab users ke)
  Future<Response> adminGetAllOrders() async {
    final response = await dio.get(ApiConstants.adminOrderGetAll);
    return response;
  }

  /// ✅ ADMIN - UPDATE ORDER STATUS
  Future<Response> adminUpdateStatus({
    required String orderId,
    required String status,
  }) async {
    final response = await dio.post(
      ApiConstants.adminOrderUpdateStatus(orderId),
      data: {"status": status},
    );
    return response;
  }
}




// ═══════════════════════════════════════════════════════════
// 📁 STEP 2.5: utils/api_constants.dart MEIN YEH ADD KAREIN
// ═══════════════════════════════════════════════════════════

/*
// ─────────────────────────────────────────
// ORDER ENDPOINTS
// ─────────────────────────────────────────
static const String orderCreate = "$baseUrl/order/create";
static const String orderGetAll = "$baseUrl/order/getAll";
static String orderById(String id) => "$baseUrl/order/$id";
static String orderCancel(String id) => "$baseUrl/order/cancel/$id";
*/

