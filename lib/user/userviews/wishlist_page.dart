
// ═══════════════════════════════════════════════════════════
// 📁 ui/user/wishlist_page.dart
// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopora/user/provider/wishlist_provider.dart'; // apna sahi path
import 'package:shopora/utils/api_constants.dart';
import 'package:shopora/user/userviews/product_detail_page.dart'; // apna sahi path

class WishlistPage extends ConsumerStatefulWidget {
  const WishlistPage({super.key});

  @override
  ConsumerState<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends ConsumerState<WishlistPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_fetchWishlist);
  }

  void _fetchWishlist() {
    ref.read(wishlistListProvider.notifier).callApi(
          () => ref.read(wishlistRepositoryProvider).getMyWishlist(),
        );
  }

  String _getImageUrl(List<dynamic> images) {
    if (images.isNotEmpty) {
      return "${ApiConstants.baseUrl}${images[0]}";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    final wishlistState = ref.watch(wishlistListProvider);
    final items = wishlistState.data ?? [];

    /// ✅ Remove hone pe list refresh karein
    ref.listen(removeWishlistProvider, (previous, next) {
      if (next.data != null && previous?.data == null) {
        ref.read(removeWishlistProvider.notifier).reset();
        _fetchWishlist();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text("My Wishlist"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: wishlistState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : wishlistState.error != null
              ? Center(child: Text(wishlistState.error!))
              : items.isEmpty
                  ? const Center(child: Text("Your wishlist is empty"))
                  : RefreshIndicator(
                      onRefresh: () async => _fetchWishlist(),
                      child: GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.68,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final imageUrl = _getImageUrl(item.images);

                          return GestureDetector(
                            // ✅ CLICK KARNE PE PRODUCT DETAIL PAGE PE JAYEGA
                            onTap: () {
                              final productMap = <String, dynamic>{
                                "_id": item.productId,
                                "name": item.name,
                                "description": item.description,
                                "price": item.price,
                                "images": item.images,
                                "rating": item.rating,
                                "stock": item.stock,
                                "brand": item.brand,
                                "category": item.category,
                              };

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetailPage(product: productMap),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius
                                            .vertical(
                                                top: Radius.circular(16)),
                                        child: imageUrl.isNotEmpty
                                            ? Image.network(
                                                imageUrl,
                                                height: 110,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (_, __, ___) => Container(
                                                  height: 110,
                                                  color:
                                                      Colors.grey.shade200,
                                                  child: const Icon(Icons
                                                      .image_not_supported_outlined),
                                                ),
                                              )
                                            : Container(
                                                height: 110,
                                                color: Colors.grey.shade200,
                                                child: const Icon(Icons
                                                    .image_not_supported_outlined),
                                              ),
                                      ),

                                      /// ✅ REMOVE (Heart) BUTTON
                                      Positioned(
                                        top: 6,
                                        right: 6,
                                        child: GestureDetector(
                                          // ✅ Card ke onTap se conflict na ho,
                                          // isliye alag GestureDetector hai
                                          onTap: () {
                                            ref
                                                .read(removeWishlistProvider
                                                    .notifier)
                                                .callApi(
                                                  () => ref
                                                      .read(
                                                          wishlistRepositoryProvider)
                                                      .removeFromWishlist(
                                                          item.productId),
                                                );
                                          },
                                          child: Container(
                                            padding:
                                                const EdgeInsets.all(6),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Rs. ${item.price.toStringAsFixed(0)}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepPurple,
                                          ),
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