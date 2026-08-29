import 'dart:io';

class ProductModel {
  final String name;
  final double price;
  final String description;
  //final File? imageFile; // ✅ Device se select ki gayi image (upload ke waqt)
 final List<File> imageFiles;
  final String category;
  final String brand;
  final double rating;
  final double stock;
  ProductModel({
    required this.name,
    required this.price,
    required this.description,
   // this.imageFile,
     this.imageFiles = const [], 
    required this.category,
    required this.brand,
    required this.rating,
    required this.stock,
  });

  // ✅ toMap - Sirf simple text fields ke liye (FormData mein image alag se add hogi)
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "price": price,
      "description": description,
      "rating": rating,
      "stock": stock,
      "brand": brand,
      "category": category,
    };
  }

  // ✅ fromMap - Backend se aane wala data (jab products list karein)
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      name: map['name'] ?? "",
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      description: map['description'] ?? "",
      imageFiles: [],
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      stock: (map['stock'] as num?)?.toDouble() ?? 0.0,
      brand: map['brand'] ?? "",
      category: map['category'] ?? "",
    );
  }

  ProductModel copyWith({
    String? name,
    double? price,
    String? description,
   // File? imageFile,
    List<File>? imageFiles,
    double? rating,
    double? stock,
    String? brand,
    String? category,
  }) {
    return ProductModel(
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      imageFiles: imageFiles ?? this.imageFiles,
      rating: rating ?? this.rating,
      stock: stock ?? this.stock,
      brand: brand ?? this.brand,
      category: category ?? this.category,
    );
  }
}
