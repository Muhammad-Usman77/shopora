// import 'package:dio/dio.dart';
// import 'package:cookie_jar/cookie_jar.dart';
// import 'package:dio_cookie_manager/dio_cookie_manager.dart';

// final dio = Dio();

// final cookieJar = CookieJar();

// void setupApi() {
//   dio.interceptors.add(
//     CookieManager(cookieJar),
//   );
// }

// ═══════════════════════════════════════════════════════════
// 📁 FILE 1: api_client.dart
// (PersistCookieJar — cookies ab disk pe save hongi)
// ═══════════════════════════════════════════════════════════

// import 'package:dio/dio.dart';
// import 'package:cookie_jar/cookie_jar.dart';
// import 'package:dio_cookie_manager/dio_cookie_manager.dart';
// import 'package:path_provider/path_provider.dart';

// final dio = Dio();

// late PersistCookieJar cookieJar;

// Future<void> setupApi() async {
//   final appDocDir = await getApplicationDocumentsDirectory();
//   final cookiePath = "${appDocDir.path}/.cookies/";

//   cookieJar = PersistCookieJar(
//     ignoreExpires: true,
//     storage: FileStorage(cookiePath),
//   );

//   dio.interceptors.add(
//     CookieManager(cookieJar),
//   );
// }


import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shopora/utils/api_constants.dart';

// final dio = Dio();
final dio = Dio(
  BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
    sendTimeout: const Duration(seconds: 20),
  ),
);
late PersistCookieJar cookieJar;
// api client setup function
Future<void> setupApi() async {
  final appDocDir = await getApplicationDocumentsDirectory();
  final cookiePath = "${appDocDir.path}/.cookies/";

  cookieJar = PersistCookieJar(
    ignoreExpires: true,
    storage: FileStorage(cookiePath),
  );

  dio.interceptors.add(
    CookieManager(cookieJar),
  );
 // ✅ YEH 2 LINES ADD KAREIN
  // dio.options.connectTimeout = const Duration(seconds: 20);
  // dio.options.receiveTimeout = const Duration(seconds: 20);

  print("✅ setupApi() called - cookies will be saved at: $cookiePath");
}