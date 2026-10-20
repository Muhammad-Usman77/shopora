
// 📁 provider/address_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shopora/auth/authprovider.dart';
import 'package:shopora/model/address_model.dart';
import 'package:shopora/user/repository/address_repository.dart';
import 'package:shopora/user/services/adddress_services.dart';
// StateNotifierProvider for managing API state related to addresses
final addressServicesProvider = Provider<AddressServices>((ref) => AddressServices());
final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  return AddressRepository(ref.watch(addressServicesProvider));
});

final addAddressProvider =
    StateNotifierProvider<ApiNotifier<Map<String, dynamic>>, ApiState<Map<String, dynamic>>>(
  (ref) => ApiNotifier<Map<String, dynamic>>(),
);

final addressListProvider =
    StateNotifierProvider<ApiNotifier<List<AddressModel>>, ApiState<List<AddressModel>>>(
  (ref) => ApiNotifier<List<AddressModel>>(),
);

final deleteAddressProvider =
    StateNotifierProvider<ApiNotifier<Map<String, dynamic>>, ApiState<Map<String, dynamic>>>(
  (ref) => ApiNotifier<Map<String, dynamic>>(),
);

