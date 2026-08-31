import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopora/admin/provider/authprovider.dart';
import 'package:shopora/home.dart';
import 'package:shopora/views/admin_home.dart';
import 'package:shopora/views/auth/login.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authCheck = ref.watch(checkAuthProvider);

    return authCheck.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),

      error: (err, stack) => const LoginPage(),

      data: (user) {
        if (user == null) {
          return const LoginPage();
        }

        if (user.isAdmin) {
          return const AdminHomePage();
        } else {
          return const HomePage();
        }
      },
    );
  }
}