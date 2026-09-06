
// ═══════════════════════════════════════════════════════════
// 📁 provider/wishlist_provider.dart
// ═══════════════════════════════════════════════════════════

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shopora/auth/authprovider.dart';
import 'package:shopora/model/whishlist_model.dart';

import 'package:shopora/user/repository/wishlist_repository.dart';
import 'package:shopora/user/services/wishlist_service.dart';


final wishlistServicesProvider = Provider<WishlistServices>((ref) {
  return WishlistServices();
});

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  final services = ref.watch(wishlistServicesProvider);
  return WishlistRepository(services);
});

final addWishlistProvider =
    StateNotifierProvider<ApiNotifier<Map<String, dynamic>>, ApiState<Map<String, dynamic>>>(
  (ref) => ApiNotifier<Map<String, dynamic>>(),
);

final wishlistListProvider =
    StateNotifierProvider<ApiNotifier<List<WishlistItemModel>>, ApiState<List<WishlistItemModel>>>(
  (ref) => ApiNotifier<List<WishlistItemModel>>(),
);

final removeWishlistProvider =
    StateNotifierProvider<ApiNotifier<Map<String, dynamic>>, ApiState<Map<String, dynamic>>>(
  (ref) => ApiNotifier<Map<String, dynamic>>(),
);