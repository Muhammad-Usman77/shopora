
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
                                        "Order #${payment.orderId.length >= 8 ? payment.orderId.substring(0, 8) : payment.orderId}",
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
                                          color: _statusColor(
                                                  payment.paymentStatus)
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          payment.paymentStatus.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: _statusColor(
                                                payment.paymentStatus),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    "Method: ${payment.paymentMethod}",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    "Rs. ${payment.amount.toStringAsFixed(0)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple,
                                      fontSize: 15,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  /// ✅ ADMIN ACTIONS (Approve/Fail/Refund)
                                  AdminPaymentActions(
                                    paymentId: payment.id,
                                    currentStatus: payment.paymentStatus,
                                    onUpdated: _fetchPayments,
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


// ═══════════════════════════════════════════════════════════
// 📌 NOTE: AdminPaymentActions widget already pehle bana chuke
// hain (upar wale message mein) - usi file ko import karein:
// import 'package:shopora/admin/ui/admin_payment_card.dart';
// ═══════════════════════════════════════════════