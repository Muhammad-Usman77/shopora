import 'package:dio/dio.dart';
import 'package:shopora/api_client.dart';

class ProductServices {
  Future<Response> getProducts() async {
    final String url = "http://192.168.1.104:3000/product/getAll";

  
   final response = await dio.get(url);
   return response;
    
  }
  
}
