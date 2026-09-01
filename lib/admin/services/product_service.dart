import 'dart:io' show File;
import 'package:dio/dio.dart';
import 'package:shopora/api_client.dart';
import 'package:shopora/model/product_model.dart';

class ProductServices {
  Future<Response> addProduct(ProductModel product) async {
    const String url = "http://192.168.1.105:3000/product/create";

    // ✅ Har image ko MultipartFile mein convert karke List banayein
    List<MultipartFile> imageFilesList = [];

    for (File file in product.imageFiles) {
      imageFilesList.add(
        await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      );
    }

    final formData = FormData.fromMap({
      "name": product.name,
      "price": product.price,
      "description": product.description,

      // ✅ "images" field mein List<MultipartFile> jayega (array ki tarah)
      "images": imageFilesList,
      "rating": product.rating,
      "stock": product.stock,
      "brand": product.brand,
      "category": product.category,
    });

    final response = await dio.post(url, data: formData);
    return response;
  }

  Future<Response> addTwo(ProductModel productt) async {
    const String url = "";
    List<MultipartFile> fileList = [];

    for (File file in productt.imageFiles) {
      fileList.add(
        await MultipartFile.fromFile(
          file.path,
          filename: file.path.split("/").last,
        ),
      );
    }

    final  formData = FormData.fromMap({
      "name": productt.name,
      "price": productt.price,
      "description": productt.description,
      "images": fileList,
      "rating": productt.rating,
      "stock": productt.stock,
      "brand": productt.brand,
      "category": productt.category,
    });
    final response = await dio.post(url, data: formData);
    return response;
  }

  /// ✅ ADD PRODUCT (with single image upload)
  // Future<Response> addProduct(ProductModel product) async {
  //   const String url = "http://192.168.1.106:3000/product";

  //   // ✅ FormData banayein - JSON ki jagah
  //   final formData = FormData.fromMap({
  //     "name": product.name,
  //     "price": product.price,
  //     "description": product.description,

  //     // ✅ Image file ko MultipartFile mein convert karein
  //     if (product.imageFile != null)
  //       "images": await MultipartFile.fromFile(
  //         product.imageFile!.path,
  //         filename: product.imageFile!.path.split('/').last,
  //       ),
  //   });

  //   final response = await dio.post(
  //     url,
  //     data: formData,   // ✅ jsonEncode() ki jagah FormData jayega
  //   );

  //   return response;
  // }

  /// ✅ GET ALL PRODUCTS (yeh normal GET hai, koi change nahi)
  Future<Response> getProducts() async {
    const String url = "http://192.168.1.105:3000/product/getAll";
    final response = await dio.get(url);
    return response;
  }

  Future<Response> updateProduct(String id, ProductModel product) async {
    final String url = "http://192.168.1.105:3000/product/$id";

    // ✅ Har image ko MultipartFile mein convert karke List banayein
    List<MultipartFile> imageFilesList = [];

    for (File file in product.imageFiles) {
      imageFilesList.add(
        await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      );
    }

    final formData = FormData.fromMap({
      "name": product.name,
      "price": product.price,
      "description": product.description,
      "rating": product.rating,
      "stock": product.stock,
      "brand": product.brand,
      "category": product.category,
      // ✅ Agar naye images select ki hain to bhejein, warna khali list
      if (imageFilesList.isNotEmpty) "images": imageFilesList,
    });

    final response = await dio.patch(url, data: formData);
    return response;
  }

  /// ✅ UPDATE PRODUCT (agar image bhi update karni ho, to yeh bhi FormData hoga)
  // Future<Response> updateProduct(String id, ProductModel product) async {
  //   final String url = "http://192.168.1.106:3000/product/$id";

  //   final formData = FormData.fromMap({
  //     "name": product.name,
  //     "price": product.price,
  //     "description": product.description,
  //     if (product.imageFile != null)
  //       "image": await MultipartFile.fromFile(product.imageFile!.path),
  //   });

  //   final response = await dio.put(url, data: formData);
  //   return response;
  // }

  /// ✅ DELETE PRODUCT (koi image nahi, normal request)
  Future<Response> deleteProduct(String id) async {
    final String url = "http://192.168.1.105:3000/product/$id";
    final response = await dio.delete(url);
    return response;
  }
}
