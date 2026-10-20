import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopora/user/provider/cart_provider.dart'; // apna path sahi karein
import 'package:shopora/user/userviews/checkout_page.dart';

import 'package:shopora/utils/api_constants.dart'; // ✅ apna path sahi karein

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_fetchCart);
  }

  void _fetchCart() {
    ref.read(cartListProvider.notifier).callApi(
          () => ref.read(cartRepositoryProvider).getCart(),
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
    final cartState = ref.watch(cartListProvider);

    /// ✅ Update/Remove ke baad list refresh karein
    ref.listen(updateCartProvider, (previous, next) {
      if (next.data != null && previous?.data == null) {
        ref.read(updateCartProvider.notifier).reset();
        _fetchCart();
      }
    });

    ref.listen(removeCartProvider, (previous, next) {
      if (next.data != null && previous?.data == null) {
        ref.read(removeCartProvider.notifier).reset();
        _fetchCart();
      }
    });

    final items = cartState.data ?? [];
    final double totalAmount = items.fold(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );

    print("🛒 CartPage build — isLoading: ${cartState.isLoading}, "
        "error: ${cartState.error}, items.length: ${items.length}");

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text("My Cart"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Builder(
        builder: (context) {
          if (cartState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cartState.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  cartState.error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          if (items.isEmpty) {
            return const Center(child: Text("Your cart is empty"));
          }

          return RefreshIndicator(
            onRefresh: () async => _fetchCart(),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final imageUrl = _getImageUrl(item.images);
return Container(
  margin: const EdgeInsets.only(bottom: 14),
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
  child: Padding(
    padding: const EdgeInsets.all(12),
    child: Row(
      children: [

        // =====================================================
        // PRODUCT IMAGE
        // =====================================================

        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  width: 90,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 90,
                    height: 100,
                    color: const Color(0xFFF3F1F8),
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ),
                )
              : Container(
                  width: 90,
                  height: 100,
                  color: const Color(0xFFF3F1F8),
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
        ),

        const SizedBox(width: 13),

        // =====================================================
        // PRODUCT DETAILS
        // =====================================================

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // PRODUCT NAME
              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF20202A),
                ),
              ),

              const SizedBox(height: 5),

              // PRICE
              Text(
                "Rs. ${item.price}",
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 5),

              // TOTAL PRICE
              Text(
                "Rs. ${item.totalPrice.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),

              const SizedBox(height: 10),

              // =================================================
              // QUANTITY CONTROL
              // =================================================

              Container(
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // MINUS
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 38,
                      ),
                      icon: const Icon(
                        Icons.remove,
                        size: 17,
                        color: Colors.deepPurple,
                      ),
                      onPressed: () {
                        ref
                            .read(removeCartProvider.notifier)
                            .callApi(
                              () => ref
                                  .read(cartRepositoryProvider)
                                  .removeFromCart(item.id),
                            );
                      },
                    ),

                    // QUANTITY
                    Text(
                      "${item.quantity}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // PLUS
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 38,
                      ),
                      icon: const Icon(
                        Icons.add,
                        size: 17,
                        color: Colors.deepPurple,
                      ),
                      onPressed: () {
                        ref
                            .read(updateCartProvider.notifier)
                            .callApi(
                              () => ref
                                  .read(cartRepositoryProvider)
                                  .updateQuantity(
                                    cartId: item.id,
                                    quantity: item.quantity + 1,
                                  ),
                            );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);
                // return Card(
                //   margin: const EdgeInsets.only(bottom: 12),
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(14),
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.all(10),
                //     child: Row(
                //       children: [
                //         ClipRRect(
                //           borderRadius: BorderRadius.circular(10),
                //           child: imageUrl.isNotEmpty
                //               ? Image.network(
                //                   imageUrl,
                //                   width: 65,
                //                   height: 65,
                //                   fit: BoxFit.cover,
                //                   errorBuilder: (_, _, _) => Container(
                //                     width: 65,
                //                     height: 65,
                //                     color: Colors.grey.shade200,
                //                     child: const Icon(
                //                       Icons.image_not_supported,
                //                     ),
                //                   ),
                //                 )
                //               : Container(
                //                   width: 65,
                //                   height: 65,
                //                   color: Colors.grey.shade200,
                //                   child: const Icon(
                //                     Icons.image_not_supported,
                //                   ),
                //                 ),
                //         ),
                //         const SizedBox(width: 12),
                //         Expanded(
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(
                //                 item.name,
                //                 maxLines: 1,
                //                 overflow: TextOverflow.ellipsis,
                //                 style: const TextStyle(
                //                   fontWeight: FontWeight.bold,
                //                   fontSize: 14,
                //                 ),
                //               ),
                //               const SizedBox(height: 4),
                //               Text(
                //                 "Rs. ${item.price} x ${item.quantity}",
                //                 style: TextStyle(
                //                   color: Colors.grey.shade600,
                //                   fontSize: 12,
                //                 ),
                //               ),
                //               const SizedBox(height: 4),
                //               Text(
                //                 "Rs. ${item.totalPrice.toStringAsFixed(0)}",
                //                 style: const TextStyle(
                //                   color: Colors.deepPurple,
                //                   fontWeight: FontWeight.bold,
                //                   fontSize: 14,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //         Row(
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             IconButton(
                //               icon: const Icon(
                //                 Icons.remove_circle_outline,
                //                 size: 20,
                //               ),
                //               onPressed: () {
                //                 ref
                //                     .read(removeCartProvider.notifier)
                //                     .callApi(
                //                       () => ref
                //                           .read(cartRepositoryProvider)
                //                           .removeFromCart(item.id),
                //                     );
                //               },
                //             ),
                //             Text("${item.quantity}"),
                //             IconButton(
                //               icon: const Icon(
                //                 Icons.add_circle_outline,
                //                 size: 20,
                //               ),
                //               onPressed: () {
                //                 ref
                //                     .read(updateCartProvider.notifier)
                //                     .callApi(
                //                       () => ref
                //                           .read(cartRepositoryProvider)
                //                           .updateQuantity(
                //                             cartId: item.id,
                //                             quantity: item.quantity + 1,
                //                           ),
                //                     );
                //               },
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // );
            
              },
            ),
          );
        },
      ),

      /// ✅ BOTTOM CHECKOUT BAR
      bottomNavigationBar: items.isEmpty
          ? null
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
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
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Total",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "Rs. ${totalAmount.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                       onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutPage(totalAmount: totalAmount),
      ),
    );
  },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Checkout",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}