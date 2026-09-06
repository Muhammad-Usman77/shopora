
// 📁 services/address_services.dart
import 'package:dio/dio.dart';
import 'package:shopora/api_client.dart';
import 'package:shopora/model/address_model.dart';
import 'package:shopora/utils/api_constants.dart';

class AddressServices {
  Future<Response> addAddress(AddressModel address) async {
    final response = await dio.post(ApiConstants.addressAdd, data: address.toMap());
    return response;
  }

  Future<Response> getMyAddresses() async {
    final response = await dio.get(ApiConstants.addressGetAll);
    return response;
  }

  Future<Response> updateAddress(String id, AddressModel address) async {
    final response = await dio.patch(ApiConstants.addressById(id), data: address.toMap());
    return response;
  }

  Future<Response> deleteAddress(String id) async {
    final response = await dio.delete(ApiConstants.addressById(id));
    return response;
  }
}