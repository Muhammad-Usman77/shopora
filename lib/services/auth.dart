import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shopora/api_client.dart';

class AuthServices {
  Future<Response> storeData({
    required String name,
    required String email,
    required String password,
  }) async {
    const String url = "http://192.168.1.106:3000/register";

    try {
      final response = await dio.post(
        url,
        data: {"name": name, "email": email, "password": password},
      );

      return response;
    } on DioException catch (e) {
      throw Exception(e.response?.data?["msg"] ?? "Something went wrong");
    }
  }

  // this function for login
  Future<Response> login({
    required String email,
    required String password,
  }) async {
    const String url = 'http://192.168.1.106:3000/login';

    try {
      final response = await dio.post(
        url,
        // headers: {
        //   "Content-Type": "application/json",
        //   "Accept": "application/json",
        // },
        data: jsonEncode({"email": email, "password": password}),
      );

      // print(
      //   await cookieJar.loadForRequest(Uri.parse("http://192.168.1.106:3000")),
      // );
      return response;
    } on DioException catch (e) {
      throw Exception(e.response?.data?["msg"] ?? "Login failed");
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }

  //this is for logout

  Future<void> logout() async {
    const String url = "http://192.168.1.106:3000/logout";

    try {
      final response = await dio.post(url);

      // print("Logout status: ${response.statusCode}");
      // print("Logout response: ${response.data}");

      if (response.statusCode == 200) {
        // Clear the cookie stored on Flutter side
        await cookieJar.deleteAll();
        // print(await cookieJar.loadForRequest(
        //   Uri.parse("http://192.168.1.106:3000"),
        // ));
      }
    } on DioException catch (e) {
      //   print("Logout error: ${e.message}");
      //print("Response: ${e.response?.data}");
      throw Exception("Some thing went wrokng: $e");
    }
  }
}
