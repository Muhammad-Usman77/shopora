
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shopora/user/provider/order_provider.dart';

// class OrderListPage extends ConsumerStatefulWidget {
//   const OrderListPage({super.key});

//   @override
//   ConsumerState<OrderListPage> createState() => _OrderListPageState();
// }

// class _OrderListPageState extends ConsumerState<OrderListPage> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(_fetchOrders);
//   }

//   void _fetchOrders() {
//     ref.read(orderListProvider.notifier).callApi(
//           () => ref.read(orderRepositoryProvider).getAllOrders(),
//         );
//   }

//   Color _statusColor(String status) {
//     switch (status) {
//       case "delivered":
//         return Colors.green;
//       case "cancelled":
//       case "failed":
//         return Colors.red;
//       case "shipped":
//         return Colors.blue;
//       case "confirmed":
//         return Colors.orange;
//       default:
//         return Colors.grey;
//     }
//   }

//   void _handleCancelOrder(String orderId) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Cancel Order"),
//         content: const Text("Are you sure you want to cancel this order?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("No"),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               ref.read(cancelOrderProvider.notifier).callApi(
//                     () => ref.read(orderRepositoryProvider).cancelOrder(orderId),
//                   );
//             },
//             child: const Text("Yes, Cancel", style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final orderState = ref.watch(orderListProvider);
//     final orders = orderState.data ?? [];

//     /// ✅ Cancel success hone pe list refresh karein
//     ref.listen(cancelOrderProvider, (previous, next) {
//       if (next.data != null && previous?.data == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Order Cancelled")),
//         );
//         ref.read(cancelOrderProvider.notifier).reset();
//         _fetchOrders();
//       }

//       if (next.error != null && previous?.error != next.error) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(next.error!)),
//         );
//       }
//     });

//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F7F7),
//       appBar: AppBar(
//         title: const Text("My Orders"),
//         backgroundColor: Colors.deepPurple,
//         foregroundColor: Colors.white,
//       ),
//       body: orderState.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : orderState.error != null
//               ? Center(child: Text(orderState.error!))
//               : orders.isEmpty
//                   ? const Center(child: Text("No orders yet"))
//                   : RefreshIndicator(
//                       onRefresh: () async => _fetchOrders(),
//                       child: ListView.builder(
//                         padding: const EdgeInsets.all(12),
//                         itemCount: orders.length,
//                         itemBuilder: (context, index) {
//                           final order = orders[index];

//                           return Card(
//                             margin: const EdgeInsets.only(bottom: 12),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(14),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(14),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         "Order #${order.id.substring(0, 8)}",
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 10,
//                                           vertical: 4,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: _statusColor(order.status)
//                                               .withValues(alpha: 0.1),
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                         ),
//                                         child: Text(
//                                           order.status.toUpperCase(),
//                                           style: TextStyle(
//                                             fontSize: 11,
//                                             fontWeight: FontWeight.w600,
//                                             color: _statusColor(order.status),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     "${order.products.length} item(s)",
//                                     style: TextStyle(
//                                       color: Colors.grey.shade600,
//                                       fontSize: 13,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     "Rs. ${order.totalAmount.toStringAsFixed(0)}",
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.deepPurple,
//                                       fontSize: 15,
//                                     ),
//                                   ),

//                                   /// ✅ CANCEL BUTTON - sirf pending/confirmed pe dikhega
//                                   if (order.status == "pending" ||
//                                       order.status == "confirmed") ...[
//                                     const SizedBox(height: 10),
//                                     Align(
//                                       alignment: Alignment.centerRight,
//                                       child: TextButton.icon(
//                                         onPressed: () =>
//                                             _handleCancelOrder(order.id),
//                                         icon: const Icon(Icons.close,
//                                             size: 16, color: Colors.red),
//                                         label: const Text(
//                                           "Cancel Order",
//                                           style: TextStyle(color: Colors.red),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopora/user/provider/order_provider.dart';

class OrderListPage extends ConsumerStatefulWidget {
  const OrderListPage({super.key});

  @override
  ConsumerState<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends ConsumerState<OrderListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_fetchOrders);
  }

  void _fetchOrders() {
    ref.read(orderListProvider.notifier).callApi(
          () => ref.read(orderRepositoryProvider).getAllOrders(),
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

  void _handleCancelOrder(String orderId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text(
          "Cancel Order",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "Are you sure you want to cancel this order?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);

              ref.read(cancelOrderProvider.notifier).callApi(
                    () => ref
                        .read(orderRepositoryProvider)
                        .cancelOrder(orderId),
                  );
            },
            child: const Text("Yes, Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderListProvider);
    final orders = orderState.data ?? [];

    // =========================================================
    // CANCEL ORDER LISTENER
    // =========================================================

    ref.listen(cancelOrderProvider, (previous, next) {
      if (next.data != null && previous?.data == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Order Cancelled"),
            behavior: SnackBarBehavior.floating,
          ),
        );

        ref.read(cancelOrderProvider.notifier).reset();

        _fetchOrders();
      }

      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      // =======================================================
      // APP BAR
      // =======================================================

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text(
          "My Orders",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // =======================================================
      // BODY
      // =======================================================

      body: orderState.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            )
          : orderState.error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      orderState.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              : orders.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 70,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 15),
                          Text(
                            "No orders yet",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Your orders will appear here.",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      color: Colors.deepPurple,
                      onRefresh: () async => _fetchOrders(),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          16,
                          16,
                          16,
                          25,
                        ),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];

                          final statusColor =
                              _statusColor(order.status);

                          return Container(
                            margin: const EdgeInsets.only(
                              bottom: 14,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: 0.05,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [

                                  // =================================================
                                  // ORDER HEADER
                                  // =================================================

                                  Row(
                                    children: [
                                      Container(
                                        height: 46,
                                        width: 46,
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple
                                              .withValues(alpha: 0.10),
                                          borderRadius:
                                              BorderRadius.circular(
                                            13,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons
                                              .receipt_long_outlined,
                                          color:
                                              Colors.deepPurple,
                                          size: 24,
                                        ),
                                      ),

                                      const SizedBox(width: 12),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                          children: [
                                            const Text(
                                              "Order",
                                              style: TextStyle(
                                                fontSize: 11,
                                                color:
                                                    Colors.black54,
                                              ),
                                            ),

                                            const SizedBox(height: 3),

                                            Text(
                                              "#${order.id.substring(0, 8)}",
                                              style:
                                                  const TextStyle(
                                                fontSize: 15,
                                                fontWeight:
                                                    FontWeight.bold,
                                                color:
                                                    Color(0xFF222222),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // STATUS
                                      Container(
                                        padding:
                                            const EdgeInsets
                                                .symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: statusColor
                                              .withValues(alpha: 0.10),
                                          borderRadius:
                                              BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize:
                                              MainAxisSize.min,
                                          children: [
                                            Container(
                                              height: 7,
                                              width: 7,
                                              decoration:
                                                  BoxDecoration(
                                                color: statusColor,
                                                shape:
                                                    BoxShape.circle,
                                              ),
                                            ),

                                            const SizedBox(width: 6),

                                            Text(
                                              order.status
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight:
                                                    FontWeight.bold,
                                                color: statusColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  // =================================================
                                  // ORDER DETAILS
                                  // =================================================

                                  Container(
                                    padding:
                                        const EdgeInsets.all(13),
                                    decoration: BoxDecoration(
                                      color:
                                          const Color(0xFFF8F8FA),
                                      borderRadius:
                                          BorderRadius.circular(
                                        13,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        // ITEMS
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 36,
                                                width: 36,
                                                decoration:
                                                    BoxDecoration(
                                                  color: Colors
                                                      .blue
                                                      .withValues(
                                                    alpha: 0.10,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                    10,
                                                  ),
                                                ),
                                                child: const Icon(
                                                  Icons
                                                      .shopping_bag_outlined,
                                                  color: Colors.blue,
                                                  size: 19,
                                                ),
                                              ),

                                              const SizedBox(
                                                width: 9,
                                              ),

                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                  children: [
                                                    const Text(
                                                      "Items",
                                                      style:
                                                          TextStyle(
                                                        fontSize: 10,
                                                        color: Colors
                                                            .black45,
                                                      ),
                                                    ),

                                                    const SizedBox(
                                                      height: 3,
                                                    ),

                                                    Text(
                                                      "${order.products.length} item(s)",
                                                      style:
                                                          const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight
                                                                .w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Container(
                                          height: 40,
                                          width: 1,
                                          color:
                                              Colors.grey.shade300,
                                        ),

                                        const SizedBox(width: 14),

                                        // TOTAL
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .end,
                                          children: [
                                            const Text(
                                              "Total",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color:
                                                    Colors.black45,
                                              ),
                                            ),

                                            const SizedBox(height: 3),

                                            Text(
                                              "Rs. ${order.totalAmount.toStringAsFixed(0)}",
                                              style:
                                                  const TextStyle(
                                                fontSize: 16,
                                                fontWeight:
                                                    FontWeight.bold,
                                                color:
                                                    Colors.deepPurple,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // =================================================
                                  // CANCEL ORDER
                                  // =================================================

                                  if (order.status == "pending" ||
                                      order.status ==
                                          "confirmed") ...[
                                    const SizedBox(height: 14),

                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton.icon(
                                        onPressed: () =>
                                            _handleCancelOrder(
                                          order.id,
                                        ),
                                        icon: const Icon(
                                          Icons.close,
                                          size: 18,
                                          color: Colors.red,
                                        ),
                                        label: const Text(
                                          "Cancel Order",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight:
                                                FontWeight.w600,
                                          ),
                                        ),
                                        style: OutlinedButton
                                            .styleFrom(
                                          side: BorderSide(
                                            color: Colors.red
                                                .withValues(alpha: 0.25),
                                          ),
                                          backgroundColor: Colors
                                              .red
                                              .withValues(alpha: 0.04),
                                          padding:
                                              const EdgeInsets
                                                  .symmetric(
                                            vertical: 11,
                                          ),
                                          shape:
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(
                                              11,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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