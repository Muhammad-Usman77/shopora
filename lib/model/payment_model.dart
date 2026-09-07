
// 📁 model/payment_model.dart
class PaymentModel {
  final String id;
  final String orderId;
  final double amount;
  final String paymentMethod;
  final String paymentStatus;

  PaymentModel({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.paymentMethod,
    required this.paymentStatus,
  });

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    // ✅ orderId bhi populate ho sakta hai (agar backend .populate("orderId") kare)
    final orderIdValue = map['orderId'];
    final orderIdStr = orderIdValue is Map
        ? (orderIdValue['_id'] ?? "")
        : (orderIdValue ?? "");

    return PaymentModel(
      id: map['_id'] ?? map['id'] ?? "",
      orderId: orderIdStr,
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: map['paymentMethod'] ?? "",
      paymentStatus: map['paymentStatus'] ?? "pending",
    );
  }
}

