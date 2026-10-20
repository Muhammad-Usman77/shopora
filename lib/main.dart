import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopora/api_client.dart';
import 'package:shopora/splash_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupApi();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopra',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashScreen(),
    );
  }
}


/*
1️⃣ Model       → "Data ka shape kya hai"
        ↓
2️⃣ Service     → "API ko request kaise jati hai"
        ↓
3️⃣ Repository  → "Response kaise safe banaya jata hai"
        ↓
4️⃣ Provider    → "State kaise manage hoti hai"
        ↓
5️⃣ UI          → "User action pe kya hota hai"

vue.js

now we work with socket

now we work with socket and integration of this with flutter
*/