// ═══════════════════════════════════════════════════════════
// 📁 STEP 1: constants/api_constants.dart (NAYI FILE)
// ═══════════════════════════════════════════════════════════

class ApiConstants {
  // ✅ SIRF YAHAN IP CHANGE KARNA HOGA — poore app mein automatically update ho jayega
  static const String baseUrl = "http://192.168.1.107:3000";

  // ─────────────────────────────────────────
  // AUTH ENDPOINTS
  // ─────────────────────────────────────────
  static const String register = "$baseUrl/register";
  static const String login = "$baseUrl/login";
  static const String logout = "$baseUrl/logout";
  static const String profile = "$baseUrl/profile";

  // ─────────────────────────────────────────
  // PRODUCT ENDPOINTS
  // ─────────────────────────────────────────
  static const String productCreate = "$baseUrl/product/create";
  static const String productGetAll = "$baseUrl/product/getAll";
  static String productById(String id) => "$baseUrl/product/$id";

  // ─────────────────────────────────────────
  // CART ENDPOINTS
  // ─────────────────────────────────────────
  static const String cartAdd = "$baseUrl/cart/add";
  static const String cartGetAll = "$baseUrl/cart/getAll";
  static const String cartUpdate = "$baseUrl/cart/update";
  static const String cartRemove = "$baseUrl/cart/remove";
  static const String cartClear = "$baseUrl/cart/clear";


    // ─────────────────────────────────────────
  // ORDER ENDPOINTS
  // ─────────────────────────────────────────
static const String orderCreate = "$baseUrl/order/createOrder";
static const String orderGetAll = "$baseUrl/order/getAllOrder";
static String orderById(String id) => "$baseUrl/order/$id";
static String orderCancel(String id) => "$baseUrl/order/$id";

  // ─────────────────────────────────────────
  // ADMIN ORDER ENDPOINTS
  // ─────────────────────────────────────────
  static const String adminOrderGetAll = "$baseUrl/order/admin/getAllOrders";
  static String adminOrderUpdateStatus(String id) => "$baseUrl/order/admin/status/$id";

    // ─────────────────────────────────────────
  // WISHLIST ENDPOINTS
  // ─────────────────────────────────────────
  static const String wishlistAdd = "$baseUrl/wishlist/add";
  static const String wishlistGetAll = "$baseUrl/wishlist/my";
  static const String wishlistRemove = "$baseUrl/wishlist/remove";

    // ADDRESS
  static const String addressAdd = "$baseUrl/address/add";
  static const String addressGetAll = "$baseUrl/address/my";
  static String addressById(String id) => "$baseUrl/address/$id";

  // PAYMENT
  static const String paymentCreate = "$baseUrl/payment/create";
  static const String paymentGetAll = "$baseUrl/payment/my";

  // REVIEW
  static const String reviewCreate = "$baseUrl/review/create";
  static String reviewByProduct(String productId) => "$baseUrl/review/product/$productId";
  static String reviewById(String id) => "$baseUrl/review/$id";

    // ─────────────────────────────────────────
  // ADMIN PAYMENT ENDPOINTS
  // ─────────────────────────────────────────
  static String adminPaymentUpdateStatus(String id) => "$baseUrl/payment/$id/status";
  static String adminPaymentRefund(String id) => "$baseUrl/payment/$id/refund";
    static const String adminPaymentGetAll = "$baseUrl/payment/admin/getAll";
}


// ═══════════════════════════════════════════════════════════
// 📁 STEP 2: services/auth.dart — YEH TAREEKA USE KAREIN
// ═══════════════════════════════════════════════════════════

/*
import 'package:dio/dio.dart';
import 'package:shopora/api_client.dart';
import 'package:shopora/constants/api_constants.dart';   // ✅ IMPORT KAREIN

class AuthServices {
  Future<Response> storeData({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      ApiConstants.register,   // ✅ Sirf endpoint use karein, hardcoded URL nahi
      data: {"name": name, "email": email, "password": password},
    );
    return response;
  }

  Future<Response> login({
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      ApiConstants.login,   // ✅
      data: {"email": email, "password": password},
    );
    return response;
  }

  Future<void> logout() async {
    await dio.post(ApiConstants.logout);   // ✅
  }

  Future<Response> checkAuth() async {
    final response = await dio.get(ApiConstants.profile);   // ✅
    return response;
  }
}
*/


// ═══════════════════════════════════════════════════════════
// 📁 STEP 3: services/product_services.dart — YEH TAREEKA
// ═══════════════════════════════════════════════════════════

/*
import 'package:shopora/constants/api_constants.dart';

class ProductServices {
  Future<Response> addProduct(ProductModel product) async {
    // ... formData banane ka code same ...
    final response = await dio.post(ApiConstants.productCreate, data: formData);   // ✅
    return response;
  }

  Future<Response> getProducts() async {
    final response = await dio.get(ApiConstants.productGetAll);   // ✅
    return response;
  }

  Future<Response> updateProduct(String id, ProductModel product) async {
    // ... formData same ...
    final response = await dio.patch(ApiConstants.productById(id), data: formData);   // ✅
    return response;
  }

  Future<Response> deleteProduct(String id) async {
    final response = await dio.delete(ApiConstants.productById(id));   // ✅
    return response;
  }
}
*/


// ═══════════════════════════════════════════════════════════
// 📁 STEP 4: services/cart_services.dart — YEH TAREEKA
// ═══════════════════════════════════════════════════════════

/*
import 'package:shopora/constants/api_constants.dart';

class CartServices {
  Future<Response> addToCart({required String productId, required int quantity}) async {
    final response = await dio.post(
      ApiConstants.cartAdd,   // ✅
      data: {"productId": productId, "quantity": quantity},
    );
    return response;
  }

  Future<Response> getCart() async {
    final response = await dio.get(ApiConstants.cartGetAll);   // ✅
    return response;
  }

  // ... baaqi functions bhi isi tarah
}
*/


// ═══════════════════════════════════════════════════════════
// 📁 STEP 5: UI Files Mein Images Ke Liye Bhi (baseUrl)
// ═══════════════════════════════════════════════════════════

/*
import 'package:shopora/constants/api_constants.dart';

String _getImageUrl(dynamic images) {
  if (images is List && images.isNotEmpty) {
    return "${ApiConstants.baseUrl}${images[0]}";   // ✅ Yahan bhi
  }
  return "";
}
*/