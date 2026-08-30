// ═══════════════════════════════════════════════════════════
// 📁 STEP 1: repository/auth_repository.dart
// Kaam: AuthServices ko call karta hai + safe response handling
// ═══════════════════════════════════════════════════════════

import 'package:dio/dio.dart';
import 'package:shopora/api_client.dart';

import 'package:shopora/model/login_model.dart';
import 'package:shopora/model/signup_model.dart';
import 'package:shopora/services/auth.dart';

class AuthRepository {
  final AuthServices authServices;

  AuthRepository(this.authServices);

  /// ✅ SIGNUP
  Future<Map<String, dynamic>> signup(SignupModel signupModel) async {
    try {
      final response = await authServices.storeData(
        name: signupModel.name,
        email: signupModel.email,
        password: signupModel.password,
      );
   // ✅ YAHAN ADD KAREIN - Signup ke baad cookie check
    final cookies = await cookieJar.loadForRequest(
      Uri.parse("http://192.168.1.106:3000"),
    );
    // print("🔵 SIGNUP - Cookies: $cookies");
      return _safeResponse(response.data);

    } on DioException catch (e) {
      throw Exception(_safeError(e));
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }

  /// ✅ LOGIN
  Future<Map<String, dynamic>> login(LoginModel loginModel) async {
    try {
      final response = await authServices.login(
        email: loginModel.email,
        password: loginModel.password,
      );
  // ✅ YAHAN ADD KAREIN - Login ke baad cookie check
    final cookies = await cookieJar.loadForRequest(
      Uri.parse("http://192.168.1.106:3000"),
    );
   // print("🟢 LOGIN - Cookies: $cookies");

      return _safeResponse(response.data);

    } on DioException catch (e) {
      throw Exception(_safeError(e));
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }

  /// ✅ LOGOUT
  Future<Map<String, dynamic>> logout() async {
    try {
      await authServices.logout();
        // ✅ YAHAN ADD KAREIN - Logout ke baad confirm cookies delete hui
      final cookies = await cookieJar.loadForRequest(
        Uri.parse("http://192.168.1.106:3000"),
      );
      print("🔴 LOGOUT - Cookies after delete: $cookies");
      // Yeh empty list [] print hona chahiye
      return {"message": "Logout successful"};

    } catch (e) {
      throw Exception("Logout failed: $e");
    }
  }

  // ───────────────────────────────────────────────────────
  // 🔒 PRIVATE HELPER: Safe response type checking
  // (Yeh hamesha same rahega, har repository mein reuse hoga)
  // ───────────────────────────────────────────────────────
  Map<String, dynamic> _safeResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    if (data is String) {
      return {"message": data};
    }
    if (data is List) {
      return {"data": data};
    }
    return {"message": "Unexpected response format"};
  }

  // ───────────────────────────────────────────────────────
  // 🔒 PRIVATE HELPER: Safe error extraction
  // (Yeh hamesha same rahega, har repository mein reuse hoga)
  // ───────────────────────────────────────────────────────
  String _safeError(DioException e) {
    final errorData = e.response?.data;

    if (errorData is Map && errorData["msg"] != null) {
      return errorData["msg"].toString();
    } else if (errorData is String) {
      return errorData;
    } else if (e.message != null) {
      return e.message!;
    }
    return "Something went wrong";
  }
}











/*
if (data is Map<String, dynamic>) return data;        // ✅ Normal Map
if (data is Map) return Map<String, dynamic>.from(data); // ✅ Dynamic Map
if (data is String) return {"message": data};          // ✅ Sirf String
if (data is List) return {"data": data};                // ✅ List
return {"message": "Unexpected response format"};       // ✅ Kuch aur/null
*/

// ═══════════════════════════════════════════════════════════
// 📁 SAFE VERSION: repository/auth_repository.dart
// Yeh version har type ka response handle kar sakta hai
// (Map, List, String, null) - bina crash hue
// ═══════════════════════════════════════════════════════════

// import 'package:dio/dio.dart';


// class AuthRepository {
//   final AuthService authService;

//   AuthRepository(this.authService);

//   Future<Map<String, dynamic>> login({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final response = await authService.login(
//         email: email,
//         password: password,
//       );

//       final data = response.data;

//       // ✅ CASE 1: Agar backend Map bheje (normal case)
//       if (data is Map<String, dynamic>) {
//         return data;
//       }

//       // ✅ CASE 2: Agar backend Map bheje lekin dynamic type ho
//       if (data is Map) {
//         return Map<String, dynamic>.from(data);
//       }

//       // ✅ CASE 3: Agar backend sirf String bheje
//       // (jaise "Login Successful")
//       if (data is String) {
//         return {"message": data};
//       }

//       // ✅ CASE 4: Agar backend List bheje (rare case for login)
//       if (data is List) {
//         return {"data": data};
//       }

//       // ✅ CASE 5: Agar data null ho ya kuch aur unexpected type ho
//       return {"message": "Unexpected response format"};

//     } on DioException catch (e) {
//       // ✅ Error handling - safe extraction

//       final errorData = e.response?.data;

//       String errorMessage = "Login failed";

//       if (errorData is Map && errorData["msg"] != null) {
//         errorMessage = errorData["msg"].toString();
//       } else if (errorData is String) {
//         errorMessage = errorData;
//       } else if (e.message != null) {
//         errorMessage = e.message!;
//       }

//       throw Exception(errorMessage);

//     } catch (e) {
//       throw Exception("Something went wrong: $e");
//     }
//   }
// }