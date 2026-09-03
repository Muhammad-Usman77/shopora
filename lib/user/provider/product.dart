import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shopora/auth/authprovider.dart';
import 'package:shopora/user/repository/repository.dart';
import 'package:shopora/user/services/services.dart';

final productServicesProvider = Provider<ProductServices>((ref) {
  return ProductServices();
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final services = ref.watch(productServicesProvider);

  return ProductRepository(services);
});

final productListProvider =
    StateNotifierProvider<ApiNotifier<List<dynamic>>, ApiState<List<dynamic>>>((
      ref,
    ) {
      return ApiNotifier<List<dynamic>>();
    });
