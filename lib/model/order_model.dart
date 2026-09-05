
class OrderProductModel {
  final String productId;
  final String name;
  final int quantity;
  final double price;
  final double totalPrice;

  OrderProductModel({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  });

  factory OrderProductModel.fromMap(Map<String, dynamic> map) {
    return OrderProductModel(
      productId: map['productId'] ?? "",
      name: map['name'] ?? "",
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
      price: double.tryParse(map['price'].toString()) ?? 0.0,
      totalPrice: double.tryParse(map['totalPrice'].toString()) ?? 0.0,
    );
  }
}

class OrderModel {
  final String id;
  final List<OrderProductModel> products;
  final double totalAmount;
  final String status;
  final String shippingAddress;
  final String createdAt;

  OrderModel({
    required this.id,
    required this.products,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.createdAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['_id'] ?? map['id'] ?? "",
      products: (map['products'] as List? ?? [])
          .map((p) => OrderProductModel.fromMap(p as Map<String, dynamic>))
          .toList(),
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] ?? "pending",
      shippingAddress: map['shippingAddress'] ?? "",
      createdAt: map['createdAt'] ?? "",
    );
  }
}
