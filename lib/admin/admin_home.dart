import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopora/admin/admin_order_list_page.dart';
import 'package:shopora/admin/admin_paymentlist_page.dart';
import 'package:shopora/auth/authprovider.dart';
import 'package:shopora/auth/login.dart';
import 'package:shopora/admin/product/product_list.dart';

class AdminHomePage extends ConsumerWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final logoutState = ref.watch(logoutProvider);

    ref.listen(logoutProvider, (previous, next) {
      if (next.data != null && previous?.data == null) {
         // ✅ Purana user data clear karein
    ref.read(currentUserProvider.notifier).state = null;

    // ✅ YEH LINE ADD KAREIN - loginProvider bhi reset karein
    ref.read(loginProvider.notifier).reset();
       // ✅ YEH LINE ADD KAREIN - logoutProvider khud ko bhi reset karein
    ref.read(logoutProvider.notifier).reset();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.admin_panel_settings, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 20),
            const Text(
              "Welcome Admin!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("You can manage products here"),
            const SizedBox(height: 40),
            ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProductListPage()),
    );
  },
  child: const Text("Manage Products"),
),
 const SizedBox(height: 40),
 ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AdminOrderListPage()),
    );
  },
  child: const Text("Admin Order List Page"),
),
 const SizedBox(height: 40),
  ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AdminPaymentListPage()),
    );
  },
  child: const Text("All Payments"),
),
 const SizedBox(height: 40),
  const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(logoutProvider.notifier).callApi(
                      () => ref.read(authRepositoryProvider).logout(),
                    );
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text("Logout", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}