import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopora/admin/provider/product_provider.dart';
import 'package:shopora/admin/product/addproduct.dart';
import 'package:shopora/admin/product/product_edit.dart';
import 'package:shopora/utils/api_constants.dart';

class ProductListPage extends ConsumerStatefulWidget {
  const ProductListPage({super.key});

  @override
  ConsumerState<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends ConsumerState<ProductListPage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(_fetchProducts);
  }

  void _fetchProducts() {
    ref.read(productsListProvider.notifier).callApi(
          () => ref.read(productRepositoryProvider).getProducts(),
        );
  }

  void _handleDelete(String productId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Product"),
        content: const Text("Are you sure you want to delete this product?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(deleteProductProvider.notifier).callApi(
                    () => ref.read(productRepositoryProvider).deleteProduct(productId),
                  );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

// static const String baseUrl = "http://192.168.1.104:3000";

String _getImageUrl(dynamic images) {
  if (images is List && images.isNotEmpty) {
    return "${ApiConstants.baseUrl}${images[0]}";   // ✅ Yeh use karein
  }
  return "";
}
  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsListProvider);

    /// ✅ Delete success hone pe list refresh karein
    ref.listen(deleteProductProvider, (previous, next) {
      if (next.data != null && previous?.data == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product Deleted")),
        );
        ref.read(deleteProductProvider.notifier).reset();
        _fetchProducts();
      }

      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Products"),
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductPage()),
          );
          _fetchProducts(); // ✅ Wapis aane pe list refresh
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _fetchProducts(),
        child: productsState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : productsState.error != null
                ? Center(child: Text(productsState.error!))
                : (productsState.data == null || productsState.data!.isEmpty)
                    ? const Center(child: Text("No products yet"))
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: productsState.data!.length,
                        itemBuilder: (context, index) {
                          final product = productsState.data![index] as Map<String, dynamic>;

final imageUrl = _getImageUrl(product['images']);
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: imageUrl.isNotEmpty
    ? Image.network(
        imageUrl,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          width: 70,
          height: 70,
          color: Colors.grey.shade200,
          child: const Icon(Icons.image_not_supported),
        ),
      )
    : Container(
        width: 70,
        height: 70,
        color: Colors.grey.shade200,
        child: const Icon(Icons.image_not_supported),
      ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product['name'] ?? "",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 15),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Rs. ${product['price'] ?? 0}",
                                          style: const TextStyle(color: Colors.deepPurple),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => EditProductPage(product: product),
                                        ),
                                      );
                                      _fetchProducts();
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _handleDelete(product['_id'] ?? product['id']),
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