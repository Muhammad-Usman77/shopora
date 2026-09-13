
// 📁 repository/address_repository.dart
import 'package:dio/dio.dart';
import 'package:shopora/model/address_model.dart';
import 'package:shopora/user/services/adddress_services.dart';

class AddressRepository {
  final AddressServices addressServices;
  AddressRepository(this.addressServices);

  Future<Map<String, dynamic>> addAddress(AddressModel address) async {
    try {
      final response = await addressServices.addAddress(address);
      return _safeResponse(response.data);
    } on DioException catch (e) {
      throw Exception(_safeError(e));
    }
  }

  Future<List<AddressModel>> getMyAddresses() async {
    try {
      final response = await addressServices.getMyAddresses();
      final data = response.data;
      List<dynamic> rawList = [];
      if (data is Map && data['data'] is List) {
        rawList = data['data'];
      } else if (data is List) rawList = data;
      return rawList.map((e) => AddressModel.fromMap(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw Exception(_safeError(e));
    }
  }

  Future<Map<String, dynamic>> deleteAddress(String id) async {
    try {
      final response = await addressServices.deleteAddress(id);
      return _safeResponse(response.data);
    } on DioException catch (e) {
      throw Exception(_safeError(e));
    }
  }

  Map<String, dynamic> _safeResponse(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is String) return {"message": data};
    if (data is List) return {"data": data};
    return {"message": "Unexpected response format"};
  }

  String _safeError(DioException e) {
    final errorData = e.response?.data;
    if (errorData is Map && errorData["msg"] != null) return errorData["msg"].toString();
    if (errorData is String) return errorData;
    if (e.message != null) return e.message!;
    return "Something went wrong";
  }
}
