import 'package:dio/dio.dart';
import 'package:shopora/api_client.dart';
import 'package:shopora/utils/api_constants.dart';

class ProductServices {
  Future<Response> getProducts() async {
    final String url = "${ApiConstants.baseUrl}/product/getAll";

  
   final response = await dio.get(url);
   return response;
    
  }
  
}
