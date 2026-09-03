
// ═══════════════════════════════════════════════════════════
// 📁 STEP 1: model/cart_model.dart
// ═══════════════════════════════════════════════════════════

class CartItemModel {
  final String id;
  final String productId;
  final String name;
  final String description;
  final int quantity;
  final double price;
  final List<dynamic> images;
  final double totalPrice;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.description,
    required this.quantity,
    required this.price,
    required this.images,
    required this.totalPrice,
  });

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['_id'] ?? map['id'] ?? "",
      productId: map['productId'] ?? "",
      name: map['name'] ?? "",
      description: map['description'] ?? "",
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      images: map['images'] ?? [],
      totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
