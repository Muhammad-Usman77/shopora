// ═══════════════════════════════════════════════════════════
// 📁 PAGE: ui/user/product_browse_page.dart
// User side - sirf dekhne ke liye (Add/Edit/Delete nahi)
// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopora/user/provider/product.dart';
import 'package:shopora/user/userviews/product_detail_page.dart';
// ✅ apna sahi path daalein

class ProductBrowsePage extends ConsumerStatefulWidget {
  const ProductBrowsePage({super.key});

  @override
  ConsumerState<ProductBrowsePage> createState() => _ProductBrowsePageState();
}

class _ProductBrowsePageState extends ConsumerState<ProductBrowsePage> {
  // ✅ Backend ka base URL (image path ke sath jodne ke liye)
  static const String baseUrl = "http://192.168.1.105:3000";

  @override
  void initState() {
    super.initState();
    Future.microtask(_fetchProducts);
  }

  void _fetchProducts() {
    ref
        .read(productListProvider.notifier)
        .callApi(() => ref.read(productRepositoryProvider).getAllProducts());
  }

  /// ✅ Image ka path backend se relative hota hai (jaise "uploads/xyz.jpg")
  /// Isay poora URL banana zaroori hai dikhane ke liye
  String _getImageUrl(dynamic images) {
    if (images is List && images.isNotEmpty) {
      return "$baseUrl${images[0]}"; // ✅ Admin page jaisa hi tareeka
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text("Products"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async => _fetchProducts(),
        child: productsState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : productsState.error != null
            ? Center(
                child: Text(
                  productsState.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            : (productsState.data == null || productsState.data!.isEmpty)
            ? const Center(child: Text("No products available"))
            : GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.62,
                ),
                itemCount: productsState.data!.length,
                itemBuilder: (context, index) {
                  final product =
                      productsState.data![index] as Map<String, dynamic>;

                  final imageUrl = _getImageUrl(product['images']);
                  final stock = (product['stock'] as num?)?.toDouble() ?? 0;
                  final rating = (product['rating'] as num?)?.toDouble() ?? 0;

                  return GestureDetector(
                    onTap: () {
                      // ✅ Baad mein: Product Detail Page pe navigate karein
                       Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailPage(product: product),
      ),
    );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// ✅ IMAGE
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                child: imageUrl.isNotEmpty
                                    ? Image.network(
                                        imageUrl,
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) => Container(
                                          height: 120,
                                          color: Colors.grey.shade200,
                                          child: const Icon(
                                            Icons.image_not_supported_outlined,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 120,
                                        color: Colors.grey.shade200,
                                        child: const Icon(
                                          Icons.image_not_supported_outlined,
                                          color: Colors.grey,
                                        ),
                                      ),
                              ),

                              /// ✅ Rating badge
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 12,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        rating.toStringAsFixed(1),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// ✅ BRAND
                                if ((product['brand'] ?? "")
                                    .toString()
                                    .isNotEmpty)
                                  Text(
                                    product['brand'].toString(),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                const SizedBox(height: 2),

                                /// ✅ NAME
                                Text(
                                  product['name'] ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                /// ✅ SHORT DESCRIPTION
                                Text(
                                  product['description'] ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: Colors.grey.shade600,
                                    height: 1.3,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                /// ✅ PRICE + STOCK
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Rs. ${product['price'] ?? 0}",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                    Text(
                                      stock > 0 ? "In Stock" : "Out of Stock",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: stock > 0
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
