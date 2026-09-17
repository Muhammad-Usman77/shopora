// ═══════════════════════════════════════════════════════════
// 📁 PAGE: ui/user/product_detail_page.dart
// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopora/user/provider/cart_provider.dart';
import 'package:shopora/user/userviews/review_section_page.dart';
import 'package:shopora/utils/api_constants.dart'; // ✅ apna sahi path daalein

// ✅ StatelessWidget ki jagah ConsumerWidget
class ProductDetailPage extends ConsumerWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({super.key, required this.product});

  static const String baseUrl = ApiConstants.baseUrl;

  List<String> _getImageUrls() {
    final images = product['images'] as List?;
    if (images == null || images.isEmpty) return [];
    return images.map((img) => "$baseUrl$img").toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {   // ✅ ref add hua
    final imageUrls = _getImageUrls();
    final stock = (product['stock'] as num?)?.toDouble() ?? 0;
    final rating = (product['rating'] as num?)?.toDouble() ?? 0;

    // ✅ Add to Cart state watch karein
    final addState = ref.watch(addToCartProvider);

    // ✅ Success/Error listen karein
    ref.listen(addToCartProvider, (previous, next) {
      if (next.data != null && previous?.data == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.data!["msg"] ?? "Added to cart")),
        );
        ref.read(addToCartProvider.notifier).reset();
      }
      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [

          /// ✅ IMAGE CAROUSEL (SliverAppBar)
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: imageUrls.isNotEmpty
                  ? PageView.builder(
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          imageUrls[index],
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),

          /// ✅ DETAILS SECTION
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// ✅ BRAND
                  if ((product['brand'] ?? "").toString().isNotEmpty)
                    Text(
                      product['brand'].toString().toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade500,
                        letterSpacing: 1,
                      ),
                    ),

                  const SizedBox(height: 6),

                  /// ✅ NAME + RATING
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product['name'] ?? "",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  /// ✅ CATEGORY
                  if ((product['category'] ?? "").toString().isNotEmpty)
                    Text(
                      product['category'].toString(),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),

                  const SizedBox(height: 16),

                  /// ✅ PRICE + STOCK
                  Row(
                    children: [
                      Text(
                        "Rs. ${product['price'] ?? 0}",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: stock > 0
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          stock > 0 ? "In Stock" : "Out of Stock",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: stock > 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 36),

                  /// ✅ DESCRIPTION
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(height: 36),

// ✅ YEH ADD KAREIN (Description section ke baad)
ReviewSection(productId: product['_id'] ?? product['id']),

const SizedBox(height: 100),
                  Text(
                    product['description'] ?? "",
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 100), // Bottom button ke liye jagah
                ],
              ),
            ),
          ),
        ],
      ),

      /// ✅ BOTTOM ADD TO CART BAR
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              // ✅ YAHAN CONNECT HUA HAI
              onPressed: (stock > 0 && !addState.isLoading)
                  ? () {
                      ref.read(addToCartProvider.notifier).callApi(
                            () => ref.read(cartRepositoryProvider).addToCart(
                                  productId:
                                      product['_id'] ?? product['id'],
                                  quantity: 1,
                                ),
                          );
                    }
                  : null,
              icon: addState.isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.shopping_cart_outlined),
              label: Text(
                addState.isLoading ? "Adding..." : "Add to Cart",
                style: const TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}