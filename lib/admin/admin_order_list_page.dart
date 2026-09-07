// ═══════════════════════════════════════════════════════════
// 📁 STEP 1: services/order_services.dart MEIN ADD KAREIN
// ═══════════════════════════════════════════════════════════

/*
class OrderServices {
  // ... existing createOrder, getAllOrders, getOrderById, cancelOrder ...

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
*/


// ═══════════════════════════════════════════════════════════
// 📁 STEP 2: repository/order_repository.dart MEIN ADD KAREIN
// ═══════════════════════════════════════════════════════════

/*
class OrderRepository {
  // ... existing functions ...

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
*/


// ═══════════════════════════════════════════════════════════
// 📁 STEP 3: provider/order_provider.dart MEIN ADD KAREIN
// ═══════════════════════════════════════════════════════════

/*
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
*/


// ═══════════════════════════════════════════════════════════
// 📁 STEP 4: ui/admin/admin_order_list_page.dart (NAYI FILE)
// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopora/user/provider/order_provider.dart'; // apna sahi path

class AdminOrderListPage extends ConsumerStatefulWidget {
  const AdminOrderListPage({super.key});

  @override
  ConsumerState<AdminOrderListPage> createState() =>
      _AdminOrderListPageState();
}

class _AdminOrderListPageState extends ConsumerState<AdminOrderListPage> {
  static const List<String> statusOptions = [
    "pending",
    "confirmed",
    "shipped",
    "delivered",
    "cancelled",
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(_fetchOrders);
  }

  void _fetchOrders() {
    ref.read(adminOrderListProvider.notifier).callApi(
          () => ref.read(orderRepositoryProvider).adminGetAllOrders(),
        );
  }

  void _handleStatusChange(String orderId, String newStatus) {
    ref.read(adminUpdateStatusProvider.notifier).callApi(
          () => ref.read(orderRepositoryProvider).adminUpdateStatus(
                orderId: orderId,
                status: newStatus,
              ),
        );
  }

  Color _statusColor(String status) {
    switch (status) {
      case "delivered":
        return Colors.green;
      case "cancelled":
      case "failed":
        return Colors.red;
      case "shipped":
        return Colors.blue;
      case "confirmed":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(adminOrderListProvider);
    final orders = orderState.data ?? [];

    /// ✅ Status update hone pe list refresh karein
    ref.listen(adminUpdateStatusProvider, (previous, next) {
      if (next.data != null && previous?.data == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order Status Updated")),
        );
        ref.read(adminUpdateStatusProvider.notifier).reset();
        _fetchOrders();
      }

      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text("Manage Orders"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: orderState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : orderState.error != null
              ? Center(child: Text(orderState.error!))
              : orders.isEmpty
                  ? const Center(child: Text("No orders yet"))
                  : RefreshIndicator(
                      onRefresh: () async => _fetchOrders(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Order #${order.id.substring(0, 8)}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _statusColor(order.status)
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          order.status.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: _statusColor(order.status),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    "${order.products.length} item(s) • Rs. ${order.totalAmount.toStringAsFixed(0)}",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    "📍 ${order.shippingAddress}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  /// ✅ STATUS DROPDOWN (Admin change kar sake)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: order.status,
                                        isExpanded: true,
                                        items: statusOptions.map((status) {
                                          return DropdownMenuItem(
                                            value: status,
                                            child: Text(
                                              status.toUpperCase(),
                                              style: const TextStyle(
                                                  fontSize: 13),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (newStatus) {
                                          if (newStatus != null &&
                                              newStatus != order.status) {
                                            _handleStatusChange(
                                                order.id, newStatus);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}