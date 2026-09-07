// ═══════════════════════════════════════════════════════════
// 📁 ui/admin/admin_payment_card.dart
// (Yeh AdminPaymentListPage ke andar EMBED hota hai, har payment card mein)
// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopora/user/provider/payment_provider.dart'; // apna sahi path

class AdminPaymentActions extends ConsumerWidget {
  final String paymentId;
  final String currentStatus;
  final VoidCallback onUpdated;

  const AdminPaymentActions({
    super.key,
    required this.paymentId,
    required this.currentStatus,
    required this.onUpdated,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateState = ref.watch(updatePaymentStatusProvider);
    final refundState = ref.watch(refundPaymentProvider);

    ref.listen(updatePaymentStatusProvider, (previous, next) {
      if (next.data != null && previous?.data == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment Status Updated")),
        );
        ref.read(updatePaymentStatusProvider.notifier).reset();
        onUpdated();
      }
      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    ref.listen(refundPaymentProvider, (previous, next) {
      if (next.data != null && previous?.data == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment Refunded")),
        );
        ref.read(refundPaymentProvider.notifier).reset();
        onUpdated();
      }
      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    final isLoading = updateState.isLoading || refundState.isLoading;

    // ✅ Case 1: Payment "pending" hai — Approve/Fail buttons dikhein
    if (currentStatus == "pending") {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: isLoading
                  ? null
                  : () {
                      ref.read(updatePaymentStatusProvider.notifier).callApi(
                            () => ref
                                .read(paymentRepositoryProvider)
                                .updatePaymentStatus(
                                  paymentId: paymentId,
                                  paymentStatus: "paid",
                                ),
                          );
                    },
              icon: const Icon(Icons.check, size: 16, color: Colors.green),
              label: const Text("Approve",
                  style: TextStyle(color: Colors.green, fontSize: 12)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.green),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: isLoading
                  ? null
                  : () {
                      ref.read(updatePaymentStatusProvider.notifier).callApi(
                            () => ref
                                .read(paymentRepositoryProvider)
                                .updatePaymentStatus(
                                  paymentId: paymentId,
                                  paymentStatus: "failed",
                                ),
                          );
                    },
              icon: const Icon(Icons.close, size: 16, color: Colors.red),
              label: const Text("Fail",
                  style: TextStyle(color: Colors.red, fontSize: 12)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
              ),
            ),
          ),
        ],
      );
    }

    // ✅ Case 2: Payment "paid" hai — Refund button dikhe
    if (currentStatus == "paid") {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: isLoading
              ? null
              : () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Refund Payment"),
                      content: const Text(
                          "Are you sure you want to refund this payment? Order will be cancelled."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("No"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ref
                                .read(refundPaymentProvider.notifier)
                                .callApi(
                                  () => ref
                                      .read(paymentRepositoryProvider)
                                      .refundPayment(paymentId),
                                );
                          },
                          child: const Text("Yes, Refund",
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
          icon: const Icon(Icons.undo, size: 16, color: Colors.orange),
          label: const Text("Refund Payment",
              style: TextStyle(color: Colors.orange, fontSize: 12)),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.orange),
          ),
        ),
      );
    }

    // ✅ Case 3: "failed" ya "refunded" — koi action nahi, sirf status badge
    return const SizedBox.shrink();
  }
}