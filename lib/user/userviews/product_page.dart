// ═══════════════════════════════════════════════════════════
// 📁 PAGE: ui/user/product_browse_page.dart
// User side - sirf dekhne ke liye (Add/Edit/Delete nahi)
// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopora/user/provider/product.dart';
import 'package:shopora/user/provider/wishlist_provider.dart';
import 'package:shopora/user/userviews/product_detail_page.dart';
import 'package:shopora/utils/api_constants.dart';
// ✅ apna sahi path daalein

class ProductBrowsePage extends ConsumerStatefulWidget {
  const ProductBrowsePage({super.key});

  @override
  ConsumerState<ProductBrowsePage> createState() => _ProductBrowsePageState();
}

class _ProductBrowsePageState extends ConsumerState<ProductBrowsePage> {
  // ✅ Backend ka base URL (image path ke sath jodne ke liye)
  static const String baseUrl = ApiConstants.baseUrl;

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
    ref.listen(addWishlistProvider, (previous, next) {
      if (next.data != null && previous?.data == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Added to wishlist")));
        ref.read(addWishlistProvider.notifier).reset();
      }
      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error!)));
      }
    });
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
                  childAspectRatio: 0.72,
                ),
                itemCount: productsState.data!.length,
                itemBuilder: (context, index) {
                  final product =
                      productsState.data![index] as Map<String, dynamic>;

                  final imageUrl = _getImageUrl(product['images']);
                  final stock = (product['stock'] as num?)?.toDouble() ?? 0;
                  final rating = (product['rating'] as num?)?.toDouble() ?? 0;
return GestureDetector(
  // =========================================================
  // PRODUCT DETAIL — SAME LOGIC
  // =========================================================
  onTap: () {
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
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 12,
          offset: const Offset(0, 5),
        ),
      ],
    ),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // =====================================================
        // IMAGE + RATING + WISHLIST
        // =====================================================

        Stack(
          children: [

            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      height: 125,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) {
                        return Container(
                          height: 125,
                          color: const Color(0xFFF3F1F8),
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.grey,
                              size: 32,
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      height: 125,
                      color: const Color(0xFFF3F1F8),
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey,
                          size: 32,
                        ),
                      ),
                    ),
            ),

            // =================================================
            // WISHLIST BUTTON — SAME LOGIC
            // =================================================

            Positioned(
              top: 9,
              right: 9,
              child: GestureDetector(
                onTap: () {
                  ref
                      .read(addWishlistProvider.notifier)
                      .callApi(
                        () => ref
                            .read(wishlistRepositoryProvider)
                            .addToWishlist(
                              product['_id'] ?? product['id'],
                            ),
                      );
                },

                child: Container(
                  height: 36,
                  width: 36,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    color: Colors.red,
                    size: 19,
                  ),
                ),
              ),
            ),

            // =================================================
            // RATING
            // =================================================

            Positioned(
              bottom: 8,
              left: 9,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: 14,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // =====================================================
        // PRODUCT INFORMATION
        // =====================================================

        Padding(
          padding: const EdgeInsets.fromLTRB(
            12,
            11,
            12,
            12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // BRAND
              if ((product['brand'] ?? "").toString().isNotEmpty)
                Text(
                  product['brand'].toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),

              const SizedBox(height: 3),

              // PRODUCT NAME
              Text(
                product['name'] ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF20202A),
                ),
              ),

              const SizedBox(height: 5),

              // DESCRIPTION
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

              const SizedBox(height: 10),

              // =================================================
              // PRICE + STOCK
              // =================================================

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  Expanded(
                    child: Text(
                      "Rs. ${product['price'] ?? 0}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),

                  const SizedBox(width: 5),

                  // STOCK BADGE
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: stock > 0
                          ? Colors.green.withValues(alpha: 0.10)
                          : Colors.red.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      stock > 0
                          ? "In Stock"
                          : "Out of Stock",
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: stock > 0
                            ? Colors.green
                            : Colors.red,
                      ),
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


                  // return GestureDetector(
                  //   onTap: () {
                  //     // ✅ Baad mein: Product Detail Page pe navigate karein
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (_) => ProductDetailPage(product: product),
                  //       ),
                  //     );
                  //   },
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(16),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.black.withValues(alpha: 0.05),
                  //           blurRadius: 8,
                  //           offset: const Offset(0, 3),
                  //         ),
                  //       ],
                  //     ),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         /// ✅ IMAGE
                  //         Stack(
                  //           children: [
                  //             ClipRRect(
                  //               borderRadius: const BorderRadius.vertical(
                  //                 top: Radius.circular(16),
                  //               ),
                  //               child: imageUrl.isNotEmpty
                  //                   ? Image.network(
                  //                       imageUrl,
                  //                       height: 120,
                  //                       width: double.infinity,
                  //                       fit: BoxFit.cover,
                  //                       errorBuilder: (_, _, _) => Container(
                  //                         height: 120,
                  //                         color: Colors.grey.shade200,
                  //                         child: const Icon(
                  //                           Icons.image_not_supported_outlined,
                  //                           color: Colors.grey,
                  //                         ),
                  //                       ),
                  //                     )
                  //                   : Container(
                  //                       height: 120,
                  //                       color: Colors.grey.shade200,
                  //                       child: const Icon(
                  //                         Icons.image_not_supported_outlined,
                  //                         color: Colors.grey,
                  //                       ),
                  //                     ),
                  //             ),

                  //             /// ✅ Rating badge
                  //             Positioned(
                  //               top: 8,
                  //               right: 8,
                  //               child: Container(
                  //                 padding: const EdgeInsets.symmetric(
                  //                   horizontal: 6,
                  //                   vertical: 3,
                  //                 ),
                  //                 decoration: BoxDecoration(
                  //                   color: Colors.black87,
                  //                   borderRadius: BorderRadius.circular(8),
                  //                 ),
                  //                 child: Row(
                  //                   mainAxisSize: MainAxisSize.min,
                  //                   children: [
                  //                     const Icon(
                  //                       Icons.star,
                  //                       color: Colors.amber,
                  //                       size: 12,
                  //                     ),
                  //                     const SizedBox(width: 3),
                  //                     Text(
                  //                       rating.toStringAsFixed(1),
                  //                       style: const TextStyle(
                  //                         color: Colors.white,
                  //                         fontSize: 11,
                  //                         fontWeight: FontWeight.w600,
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),

                  //             /// ✅ WISHLIST HEART BUTTON
                  //             Positioned(
                  //               top: 8,
                  //               left: 8,
                  //               child: GestureDetector(
                  //                 onTap: () {
                  //                   ref
                  //                       .read(addWishlistProvider.notifier)
                  //                       .callApi(
                  //                         () => ref
                  //                             .read(wishlistRepositoryProvider)
                  //                             .addToWishlist(
                  //                               product['_id'] ?? product['id'],
                  //                             ),
                  //                       );
                  //                 },
                  //                 child: Container(
                  //                   padding: const EdgeInsets.all(6),
                  //                   decoration: const BoxDecoration(
                  //                     color: Colors.white,
                  //                     shape: BoxShape.circle,
                  //                   ),
                  //                   child: const Icon(
                  //                     Icons.favorite_border,
                  //                     color: Colors.red,
                  //                     size: 16,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),

                  //         Padding(
                  //           padding: const EdgeInsets.all(10),
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               /// ✅ BRAND
                  //               if ((product['brand'] ?? "")
                  //                   .toString()
                  //                   .isNotEmpty)
                  //                 Text(
                  //                   product['brand'].toString(),
                  //                   style: TextStyle(
                  //                     fontSize: 11,
                  //                     color: Colors.grey.shade500,
                  //                     fontWeight: FontWeight.w500,
                  //                   ),
                  //                 ),

                  //               const SizedBox(height: 2),

                  //               /// ✅ NAME
                  //               Text(
                  //                 product['name'] ?? "",
                  //                 maxLines: 1,
                  //                 overflow: TextOverflow.ellipsis,
                  //                 style: const TextStyle(
                  //                   fontSize: 14,
                  //                   fontWeight: FontWeight.bold,
                  //                 ),
                  //               ),

                  //               const SizedBox(height: 4),

                  //               /// ✅ SHORT DESCRIPTION
                  //               Text(
                  //                 product['description'] ?? "",
                  //                 maxLines: 2,
                  //                 overflow: TextOverflow.ellipsis,
                  //                 style: TextStyle(
                  //                   fontSize: 11.5,
                  //                   color: Colors.grey.shade600,
                  //                   height: 1.3,
                  //                 ),
                  //               ),

                  //               const SizedBox(height: 8),

                  //               /// ✅ PRICE + STOCK
                  //               Row(
                  //                 mainAxisAlignment:
                  //                     MainAxisAlignment.spaceBetween,
                  //                 children: [
                  //                   Text(
                  //                     "Rs. ${product['price'] ?? 0}",
                  //                     style: const TextStyle(
                  //                       fontSize: 15,
                  //                       fontWeight: FontWeight.bold,
                  //                       color: Colors.deepPurple,
                  //                     ),
                  //                   ),
                  //                   Text(
                  //                     stock > 0 ? "In Stock" : "Out of Stock",
                  //                     style: TextStyle(
                  //                       fontSize: 10,
                  //                       fontWeight: FontWeight.w600,
                  //                       color: stock > 0
                  //                           ? Colors.green
                  //                           : Colors.red,
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ],
                  //           ),
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
