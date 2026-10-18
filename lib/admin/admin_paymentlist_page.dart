
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopora/admin/admin_payment_action_card.dart';
import 'package:shopora/user/provider/payment_provider.dart'; // apna sahi path

class AdminPaymentListPage extends ConsumerStatefulWidget {
  const AdminPaymentListPage({super.key});

  @override
  ConsumerState<AdminPaymentListPage> createState() =>
      _AdminPaymentListPageState();
}

class _AdminPaymentListPageState extends ConsumerState<AdminPaymentListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_fetchPayments);
  }

  void _fetchPayments() {
    ref.read(adminPaymentListProvider.notifier).callApi(
          () => ref.read(paymentRepositoryProvider).adminGetAllPayments(),
        );
  }
 // status color based on payment status
  Color _statusColor(String status) {
    switch (status) {
      case "paid":
        return Colors.green;
      case "failed":
        return Colors.red;
      case "refunded":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(adminPaymentListProvider);
    final payments = paymentState.data ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text("Manage Payments"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: paymentState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : paymentState.error != null
              ? Center(child: Text(paymentState.error!))
              : payments.isEmpty
                  ? const Center(child: Text("No payments yet"))
                  : RefreshIndicator(
                      onRefresh: () async => _fetchPayments(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: payments.length,
                        itemBuilder: (context, index) {
                          final payment = payments[index];
return Container(
  margin: const EdgeInsets.only(bottom: 14),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 12,
        offset: const Offset(0, 5),
      ),
    ],
  ),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ------------------------------------------------
        // ORDER + STATUS
        // ------------------------------------------------
        Row(
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.10),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                color: Colors.deepPurple,
                size: 24,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Order",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    "#${payment.orderId.length >= 8 ? payment.orderId.substring(0, 8) : payment.orderId}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF222222),
                    ),
                  ),
                ],
              ),
            ),

            // STATUS BADGE
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: _statusColor(payment.paymentStatus)
                    .withOpacity(0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 7,
                    width: 7,
                    decoration: BoxDecoration(
                      color: _statusColor(
                        payment.paymentStatus,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),

                  const SizedBox(width: 6),

                  Text(
                    payment.paymentStatus.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _statusColor(
                        payment.paymentStatus,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // ------------------------------------------------
        // PAYMENT DETAILS
        // ------------------------------------------------
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8FA),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            children: [
              // PAYMENT METHOD
              Expanded(
                child: Row(
                  children: [
                    Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.credit_card_outlined,
                        color: Colors.blue,
                        size: 19,
                      ),
                    ),

                    const SizedBox(width: 9),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Payment Method",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black45,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            payment.paymentMethod,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
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
                color: Colors.grey.shade300,
              ),

              const SizedBox(width: 14),

              // AMOUNT
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Amount",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black45,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    "Rs. ${payment.amount.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // ------------------------------------------------
        // ADMIN ACTIONS
        // ------------------------------------------------
        AdminPaymentActions(
          paymentId: payment.id,
          currentStatus: payment.paymentStatus,
          onUpdated: _fetchPayments,
        ),
      ],
    ),
  ),
);
                          // return Card(
                          //   margin: const EdgeInsets.only(bottom: 12),
                          //   shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(14),
                          //   ),
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(14),
                          //     child: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Row(
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.spaceBetween,
                          //           children: [
                          //             Text(
                          //               "Order #${payment.orderId.length >= 8 ? payment.orderId.substring(0, 8) : payment.orderId}",
                          //               style: const TextStyle(
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //             ),
                          //             Container(
                          //               padding: const EdgeInsets.symmetric(
                          //                 horizontal: 10,
                          //                 vertical: 4,
                          //               ),
                          //               decoration: BoxDecoration(
                          //                 color: _statusColor(
                          //                         payment.paymentStatus)
                          //                     .withValues(alpha: 0.1),
                          //                 borderRadius:
                          //                     BorderRadius.circular(20),
                          //               ),
                          //               child: Text(
                          //                 payment.paymentStatus.toUpperCase(),
                          //                 style: TextStyle(
                          //                   fontSize: 11,
                          //                   fontWeight: FontWeight.w600,
                          //                   color: _statusColor(
                          //                       payment.paymentStatus),
                          //                 ),
                          //               ),
                          //             ),
                          //           ],
                          //         ),

                          //         const SizedBox(height: 8),

                          //         Text(
                          //           "Method: ${payment.paymentMethod}",
                          //           style: TextStyle(
                          //             color: Colors.grey.shade600,
                          //             fontSize: 13,
                          //           ),
                          //         ),

                          //         const SizedBox(height: 4),

                          //         Text(
                          //           "Rs. ${payment.amount.toStringAsFixed(0)}",
                          //           style: const TextStyle(
                          //             fontWeight: FontWeight.bold,
                          //             color: Colors.deepPurple,
                          //             fontSize: 15,
                          //           ),
                          //         ),

                          //         const SizedBox(height: 12),

                          //         /// ✅ ADMIN ACTIONS (Approve/Fail/Refund)
                          //         AdminPaymentActions(
                          //           paymentId: payment.id,
                          //           currentStatus: payment.paymentStatus,
                          //           onUpdated: _fetchPayments,
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // );
                       
                        },
                      ),
                    ),
    );
  }
}


// ═══════════════════════════════════════════════════════════
// 📌 NOTE: AdminPaymentActions widget already pehle bana chuke
// hain (upar wale message mein) - usi file ko import karein:
// import 'package:shopora/admin/ui/admin_payment_card.dart';
// ═══════════════════════════════════════════════