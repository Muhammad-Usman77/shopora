// ═══════════════════════════════════════════════════════════
// 📁 STEP 4: provider/product_provider.dart
// (100% SAME GENERIC TEMPLATE - kuch change nahi, sirf naam)
// ═══════════════════════════════════════════════════════════

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shopora/admin/provider/authprovider.dart';
import 'package:shopora/admin/repository/product_repository.dart';
import 'package:shopora/admin/services/product_service.dart';

final productServicesProvider = Provider<ProductServices>((ref) {
  return ProductServices();
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final services = ref.watch(productServicesProvider);
  return ProductRepository(services);
});

// ✅ Add Product Provider - Map return karta hai
final addProductProvider =
    StateNotifierProvider<ApiNotifier<Map<String, dynamic>>, ApiState<Map<String, dynamic>>>(
  (ref) => ApiNotifier<Map<String, dynamic>>(),
);

// ✅ Get Products Provider - List return karta hai (isliye <List<dynamic>>)
final productsListProvider =
    StateNotifierProvider<ApiNotifier<List<dynamic>>, ApiState<List<dynamic>>>(
  (ref) => ApiNotifier<List<dynamic>>(),
);

// ✅ Update/Delete bhi same pattern se
final updateProductProvider =
    StateNotifierProvider<ApiNotifier<Map<String, dynamic>>, ApiState<Map<String, dynamic>>>(
  (ref) => ApiNotifier<Map<String, dynamic>>(),
);

final deleteProductProvider =
    StateNotifierProvider<ApiNotifier<Map<String, dynamic>>, ApiState<Map<String, dynamic>>>(
  (ref) => ApiNotifier<Map<String, dynamic>>(),
);