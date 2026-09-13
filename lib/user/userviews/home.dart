//═══════════════════════════════════════════════════════════
// 📁 PAGE 3: ui/home_page.dart
// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopora/auth/authprovider.dart';
import 'package:shopora/user/userviews/cart_page.dart';
import 'package:shopora/user/userviews/lrder_list_page.dart';
import 'package:shopora/user/userviews/payment_list_page.dart';
import 'package:shopora/user/userviews/product_page.dart';
import 'package:shopora/auth/login.dart';
import 'package:shopora/user/userviews/wishlist_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logoutState = ref.watch(logoutProvider);

    /// ✅ Listen for logout success/error
    ref.listen(logoutProvider, (previous, next) {
  if (next.data != null && previous?.data == null) {
    
    // ✅ ADD KAREIN: Logout pe user data clear karein
    ref.read(currentUserProvider.notifier).state = null;
 

    // ✅ YEH LINE ADD KAREIN - loginProvider bhi reset karein
    ref.read(loginProvider.notifier).reset();
       // ✅ YEH LINE ADD KAREIN - logoutProvider khud ko bhi reset karein
    ref.read(logoutProvider.notifier).reset();
    // ✅ Navigate to Login Page after logout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  if (next.error != null && previous?.error != next.error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(next.error!)),
    );
  }
});
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),

            const SizedBox(height: 20),

            const Text(
              "Welcome! You are logged in.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 40),
           ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductBrowsePage()),
    );
  },
  child: const Text("Manage Products"),
),
  const SizedBox(height: 20),
   ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CartPage()),
    );
  },
  child: const Text("Manage Cart"),
),
 ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OrderListPage()),
    );
  },
  child: const Text("Order List"),
),
  const SizedBox(height: 20),
   ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => WishlistPage()),
    );
  },
  child: const Text("Wish List"),
),
  const SizedBox(height: 20),
   ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PaymentListPage()),
    );
  },
  child: const Text("Payment List Page"),
),
  const SizedBox(height: 20),
            /// LOGOUT BUTTON
            ElevatedButton.icon(
              onPressed: logoutState.isLoading
                  ? null
                  : () {
                      ref.read(logoutProvider.notifier).callApi(
                            () => ref.read(authRepositoryProvider).logout(),
                          );
                    },
              icon: logoutState.isLoading
                  ? const SizedBox(
                      height: 17,
                      width: 17,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.logout, color: Colors.white),
              label: Text(
                logoutState.isLoading ? "Logging out..." : "Logout",
                style: const TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}