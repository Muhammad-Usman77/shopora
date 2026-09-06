// ═══════════════════════════════════════════════════════════
// 📁 model/wishlist_model.dart
// Note: Backend "productId" ko .populate() karta hai — matlab
// yeh field poora Product object hota hai, sirf ID string nahi
// ═══════════════════════════════════════════════════════════

class WishlistItemModel {
  final String id;
  final String productId;
  final String name;
  final String description;
  final double price;
  final List<dynamic> images;
  final double rating;
  final double stock;
  final String brand;
  final String category;

  WishlistItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
  });

  factory WishlistItemModel.fromMap(Map<String, dynamic> map) {
    final product = map['productId'] is Map
        ? map['productId'] as Map<String, dynamic>
        : <String, dynamic>{};

    return WishlistItemModel(
      id: map['_id'] ?? map['id'] ?? "",
      productId: product['_id'] ?? "",
      name: product['name'] ?? "",
      description: product['description'] ?? "",
      price: (product['price'] as num?)?.toDouble() ?? 0.0,
      images: product['images'] ?? [],
      rating: (product['rating'] as num?)?.toDouble() ?? 0.0,
      stock: (product['stock'] as num?)?.toDouble() ?? 0.0,
      brand: product['brand'] ?? "",
      category: product['category'] ?? "",
    );
  }
}
