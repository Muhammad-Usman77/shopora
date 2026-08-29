
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopora/model/product_model.dart';
import 'package:shopora/provider/product_provider.dart';

class EditProductPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> product;

  const EditProductPage({super.key, required this.product});

  @override
  ConsumerState<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends ConsumerState<EditProductPage> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController categoryController;
  late TextEditingController brandController;
  late TextEditingController stockController;

  List<File> newSelectedImages = [];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product['name'] ?? "");
    priceController = TextEditingController(text: "${widget.product['price'] ?? ''}");
    descriptionController = TextEditingController(text: widget.product['description'] ?? "");
    categoryController = TextEditingController(text: widget.product['category'] ?? "");
    brandController = TextEditingController(text: widget.product['brand'] ?? "");
    stockController = TextEditingController(text: "${widget.product['stock'] ?? ''}");
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    brandController.dispose();
    stockController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await ImagePicker().pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        newSelectedImages = pickedFiles.map((xfile) => File(xfile.path)).toList();
      });
    }
  }

  void _handleUpdate() {
    final productId = widget.product['_id'] ?? widget.product['id'];

    final updatedProduct = ProductModel(
      name: nameController.text.trim(),
      price: double.tryParse(priceController.text.trim()) ?? 0.0,
      description: descriptionController.text.trim(),
      category: categoryController.text.trim(),
      brand: brandController.text.trim(),
      rating: (widget.product['rating'] as num?)?.toDouble() ?? 0.0,
      stock: double.tryParse(stockController.text.trim()) ?? 0.0,
      imageFiles: newSelectedImages, // ✅ Agar khali hai, purani images backend pe rahengi
    );

    ref.read(updateProductProvider.notifier).callApi(
          () => ref.read(productRepositoryProvider).updateProduct(productId, updatedProduct),
        );
  }

  @override
  Widget build(BuildContext context) {
    final updateState = ref.watch(updateProductProvider);

    ref.listen(updateProductProvider, (previous, next) {
      if (next.data != null && previous?.data == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product Updated Successfully!")),
        );
        ref.read(updateProductProvider.notifier).reset();
        Navigator.pop(context);
      }

      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            /// ✅ Naye images select karna (optional)
            GestureDetector(
              onTap: _pickImages,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: newSelectedImages.isEmpty
                    ? const Center(
                        child: Text(
                          "Tap to change images\n(leave empty to keep old ones)",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(8),
                        itemCount: newSelectedImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                newSelectedImages[index],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Product Name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 14),

            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Price",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 14),

            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 14),

            TextField(
              controller: categoryController,
              decoration: InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 14),

            TextField(
              controller: brandController,
              decoration: InputDecoration(
                labelText: "Brand",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 14),

            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Stock",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: updateState.isLoading ? null : _handleUpdate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: updateState.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text("Update Product", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}