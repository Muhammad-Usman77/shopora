
// ═══════════════════════════════════════════════════════════
// 📁 PAGE 2: ui/login_page.dart
// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopora/api_client.dart';
import 'package:shopora/home.dart';
import 'package:shopora/model/login_model.dart';
import 'package:shopora/model/user_model.dart';
import 'package:shopora/admin/provider/authprovider.dart';
import 'package:shopora/views/admin_home.dart';

import 'package:shopora/views/auth/signup.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    final loginModel = LoginModel(email: email, password: password);

    ref.read(loginProvider.notifier).callApi(
          () => ref.read(authRepositoryProvider).login(loginModel),
        );
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);

    /// ✅ Listen for success/error
   ref.listen(loginProvider, (previous, next) {
  if (next.data != null && previous?.data == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Login Successful!")),
    );

    // ✅ Backend se aaya "user" object nikalein
    final userData = next.data!["user"];
    final user = UserModel.fromMap(userData);

    // ✅ Global provider mein save karein
    ref.read(currentUserProvider.notifier).state = user;

    // ✅ Role check karke navigate karein
    if (user.isAdmin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminHomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  if (next.error != null && previous?.error != next.error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(next.error!)),
    );
  }
});
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Welcome Back",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                "Login to continue",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 40),

              /// EMAIL FIELD
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// PASSWORD FIELD
              TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// LOGIN BUTTON
              ElevatedButton(
                onPressed: loginState.isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.blue,
                ),
                child: loginState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Login",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),

              const SizedBox(height: 16),

              /// NAVIGATE TO SIGNUP
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupPage()),
                  );
                },
                child: const Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}