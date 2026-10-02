// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shopora/admin/admin_order_list_page.dart';
// import 'package:shopora/admin/admin_paymentlist_page.dart';
// import 'package:shopora/auth/authprovider.dart';
// import 'package:shopora/auth/login.dart';
// import 'package:shopora/admin/product/product_list.dart';

// class AdminHomePage extends ConsumerWidget {
//   const AdminHomePage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // final logoutState = ref.watch(logoutProvider);

//     ref.listen(logoutProvider, (previous, next) {
//       if (next.data != null && previous?.data == null) {
//          // ✅ Purana user data clear karein
//     ref.read(currentUserProvider.notifier).state = null;

//     // ✅ YEH LINE ADD KAREIN - loginProvider bhi reset karein
//     ref.read(loginProvider.notifier).reset();
//        // ✅ YEH LINE ADD KAREIN - logoutProvider khud ko bhi reset karein
//     ref.read(logoutProvider.notifier).reset();
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const LoginPage()),
//         );
//       }
//     });

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Admin Dashboard"),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             const Icon(Icons.admin_panel_settings, size: 80, color: Colors.deepPurple),
//             const SizedBox(height: 20),
//             const Text(
//               "Welcome Admin!",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             const Text("You can manage products here"),
//             const SizedBox(height: 40),
//             ElevatedButton(
//   onPressed: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => const ProductListPage()),
//     );
//   },
//   child: const Text("Manage Products"),
// ),
//  const SizedBox(height: 40),
//  ElevatedButton(
//   onPressed: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => AdminOrderListPage()),
//     );
//   },
//   child: const Text("Admin Order List Pagee"),
// ),
//  const SizedBox(height: 40),
//   ElevatedButton(
//   onPressed: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => AdminPaymentListPage()),
//     );
//   },
//   child: const Text("All Payments"),
// ),
//  const SizedBox(height: 40),
//   const SizedBox(height: 40),
//             ElevatedButton.icon(
//               onPressed: () {
//                 ref.read(logoutProvider.notifier).callApi(
//                       () => ref.read(authRepositoryProvider).logout(),
//                     );
//               },
//               icon: const Icon(Icons.logout, color: Colors.white),
//               label: const Text("Logout", style: TextStyle(color: Colors.white)),
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shopora/admin/admin_order_list_page.dart';
import 'package:shopora/admin/admin_paymentlist_page.dart';
import 'package:shopora/admin/product/product_list.dart';
import 'package:shopora/auth/authprovider.dart';
import 'package:shopora/auth/login.dart';

class AdminHomePage extends ConsumerWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(logoutProvider, (previous, next) {
      if (next.data != null && previous?.data == null) {
        // Clear current user
        ref.read(currentUserProvider.notifier).state = null;

        // Reset login provider
        ref.read(loginProvider.notifier).reset();

        // Reset logout provider
        ref.read(logoutProvider.notifier).reset();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginPage(),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      // ----------------------------------------------------------
      // APP BAR
      // ----------------------------------------------------------
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: "Logout",
            onPressed: () {
              _showLogoutDialog(context, ref);
            },
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 8),
        ],
      ),

      // ----------------------------------------------------------
      // BODY
      // ----------------------------------------------------------
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // --------------------------------------------------
              // WELCOME SECTION
              // --------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.deepPurple,
                      Color(0xFF7E57C2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withValues(alpha: 0.18),
                      blurRadius: 15,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      height: 58,
                      width: 58,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(width: 16),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome back, Admin 👋",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Manage your Shopora store from here.",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // --------------------------------------------------
              // QUICK ACTIONS TITLE
              // --------------------------------------------------
              const Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),

              const SizedBox(height: 15),

              // --------------------------------------------------
              // ACTION CARDS
              // --------------------------------------------------
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;

                  final cardWidth = isWide
                      ? (constraints.maxWidth - 15) / 2
                      : constraints.maxWidth;

                  return Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    children: [
                      _DashboardCard(
                        width: cardWidth,
                        icon: Icons.inventory_2_outlined,
                        title: "Products",
                        subtitle: "Manage products",
                        iconColor: Colors.deepPurple,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProductListPage(),
                            ),
                          );
                        },
                      ),

                      _DashboardCard(
                        width: cardWidth,
                        icon: Icons.shopping_bag_outlined,
                        title: "Orders",
                        subtitle: "View and manage orders",
                        iconColor: Colors.orange,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AdminOrderListPage(),
                            ),
                          );
                        },
                      ),

                      _DashboardCard(
                        width: cardWidth,
                        icon: Icons.payments_outlined,
                        title: "Payments",
                        subtitle: "View all transactions",
                        iconColor: Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AdminPaymentListPage(),
                            ),
                          );
                        },
                      ),

                      _DashboardCard(
                        width: cardWidth,
                        icon: Icons.people_outline,
                        title: "Customers",
                        subtitle: "Manage customers",
                        iconColor: Colors.blue,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Customer management coming soon",
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 30),

              // --------------------------------------------------
              // STORE OVERVIEW
              // --------------------------------------------------
              const Text(
                "Store Overview",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),

              const SizedBox(height: 15),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _OverviewItem(
                            icon: Icons.inventory_2_outlined,
                            title: "Products",
                            value: "—",
                            iconColor: Colors.deepPurple,
                          ),
                        ),

                        _verticalDivider(),

                        Expanded(
                          child: _OverviewItem(
                            icon: Icons.shopping_bag_outlined,
                            title: "Orders",
                            value: "—",
                            iconColor: Colors.orange,
                          ),
                        ),

                        _verticalDivider(),

                        Expanded(
                          child: _OverviewItem(
                            icon: Icons.payments_outlined,
                            title: "Payments",
                            value: "—",
                            iconColor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // --------------------------------------------------
              // ADMIN INFORMATION
              // --------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.deepPurple.withValues(alpha: 0.12),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.deepPurple,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Use the quick actions above to manage your Shopora store.",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------
  // LOGOUT DIALOG
  // --------------------------------------------------------------
  void _showLogoutDialog(
    BuildContext context,
    WidgetRef ref,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            "Logout",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "Are you sure you want to logout?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);

                ref.read(logoutProvider.notifier).callApi(
                      () => ref
                          .read(authRepositoryProvider)
                          .logout(),
                    );
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  // --------------------------------------------------------------
  // VERTICAL DIVIDER
  // --------------------------------------------------------------
  Widget _verticalDivider() {
    return Container(
      height: 55,
      width: 1,
      color: Colors.grey.shade300,
    );
  }
}

// ==================================================================
// DASHBOARD CARD
// ==================================================================

class _DashboardCard extends StatelessWidget {
  final double width;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.width,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 27,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF222222),
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Colors.black38,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================================================================
// OVERVIEW ITEM
// ==================================================================

class _OverviewItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;

  const _OverviewItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 21,
          ),
        ),

        const SizedBox(height: 9),

        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}