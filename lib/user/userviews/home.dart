// //═══════════════════════════════════════════════════════════
// // 📁 PAGE 3: ui/home_page.dart
// // ═══════════════════════════════════════════════════════════

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shopora/auth/authprovider.dart';
// import 'package:shopora/user/userviews/cart_page.dart';
// import 'package:shopora/user/userviews/lrder_list_page.dart';
// import 'package:shopora/user/userviews/payment_list_page.dart';
// import 'package:shopora/user/userviews/product_page.dart';
// import 'package:shopora/auth/login.dart';
// import 'package:shopora/user/userviews/wishlist_page.dart';

// class HomePage extends ConsumerWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final logoutState = ref.watch(logoutProvider);

//     /// ✅ Listen for logout success/error
//     ref.listen(logoutProvider, (previous, next) {
//   if (next.data != null && previous?.data == null) {
    
//     // ✅ ADD KAREIN: Logout pe user data clear karein
//     ref.read(currentUserProvider.notifier).state = null;
 

//     // ✅ YEH LINE ADD KAREIN - loginProvider bhi reset karein
//     ref.read(loginProvider.notifier).reset();
//        // ✅ YEH LINE ADD KAREIN - logoutProvider khud ko bhi reset karein
//     ref.read(logoutProvider.notifier).reset();
//     // ✅ Navigate to Login Page after logout
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => const LoginPage()),
//     );
//   }

//   if (next.error != null && previous?.error != next.error) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(next.error!)),
//     );
//   }
// });
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Home"),
//         backgroundColor: Colors.blue,
//         automaticallyImplyLeading: false,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.check_circle, size: 80, color: Colors.green),

//             const SizedBox(height: 20),

//             const Text(
//               "Welcome! You are logged in.",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),

//             const SizedBox(height: 40),
//            ElevatedButton(
//   onPressed: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => ProductBrowsePage()),
//     );
//   },
//   child: const Text("Manage Products"),
// ),
//   const SizedBox(height: 20),
//    ElevatedButton(
//   onPressed: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => CartPage()),
//     );
//   },
//   child: const Text("Manage Cart"),
// ),
//  ElevatedButton(
//   onPressed: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => OrderListPage()),
//     );
//   },
//   child: const Text("Order List"),
// ),
//   const SizedBox(height: 20),
//    ElevatedButton(
//   onPressed: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => WishlistPage()),
//     );
//   },
//   child: const Text("Wish List"),
// ),
//   const SizedBox(height: 20),
//    ElevatedButton(
//   onPressed: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => PaymentListPage()),
//     );
//   },
//   child: const Text("Payment List Page"),
// ),
//   const SizedBox(height: 20),
//             /// LOGOUT BUTTON
//             ElevatedButton.icon(
//               onPressed: logoutState.isLoading
//                   ? null
//                   : () {
//                       ref.read(logoutProvider.notifier).callApi(
//                             () => ref.read(authRepositoryProvider).logout(),
//                           );
//                     },
//               icon: logoutState.isLoading
//                   ? const SizedBox(
//                       height: 17,
//                       width: 17,
//                       child: CircularProgressIndicator(
//                         color: Colors.white,
//                         strokeWidth: 2,
//                       ),
//                     )
//                   : const Icon(Icons.logout, color: Colors.white),
//               label: Text(
//                 logoutState.isLoading ? "Logging out..." : "Logout",
//                 style: const TextStyle(color: Colors.white),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 30,
//                   vertical: 14,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//═══════════════════════════════════════════════════════════
// 📁 PAGE: ui/home_page.dart
// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shopora/auth/authprovider.dart';
import 'package:shopora/auth/login.dart';

import 'package:shopora/user/userviews/cart_page.dart';
import 'package:shopora/user/userviews/order_list_page.dart';
import 'package:shopora/user/userviews/payment_list_page.dart';
import 'package:shopora/user/userviews/product_page.dart';
import 'package:shopora/user/userviews/wishlist_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logoutState = ref.watch(logoutProvider);

    // =========================================================
    // LOGOUT LISTENER
    // =========================================================
    ref.listen(logoutProvider, (previous, next) {
      if (next.data != null && previous?.data == null) {
        // Clear current user
        ref.read(currentUserProvider.notifier).state = null;

        // Reset login provider
        ref.read(loginProvider.notifier).reset();

        // Reset logout provider
        ref.read(logoutProvider.notifier).reset();

        // Navigate to Login Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginPage(),
          ),
        );
      }

      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      // =======================================================
      // APP BAR
      // =======================================================
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 25,
            ),
            SizedBox(width: 10),
            Text(
              "Shopora",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            tooltip: "Logout",
            onPressed: logoutState.isLoading
                ? null
                : () {
                    ref.read(logoutProvider.notifier).callApi(
                          () => ref
                              .read(authRepositoryProvider)
                              .logout(),
                        );
                  },
            icon: logoutState.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
          ),

          const SizedBox(width: 8),
        ],
      ),

      // =======================================================
      // BODY
      // =======================================================
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // =================================================
              // WELCOME BANNER
              // =================================================
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
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withValues(alpha: 0.20),
                      blurRadius: 15,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // USER ICON
                    Container(
                      height: 58,
                      width: 58,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 31,
                      ),
                    ),

                    const SizedBox(width: 15),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome back! 👋",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 6),

                          Text(
                            "What would you like to shop today?",
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

              // =================================================
              // SHOPPING SECTION
              // =================================================
              const Text(
                "Shopping",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),

              const SizedBox(height: 14),

              // PRODUCTS
              _HomeActionCard(
                icon: Icons.shopping_bag_outlined,
                title: "Browse Products",
                subtitle: "Explore our products",
                iconColor: Colors.deepPurple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductBrowsePage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              // CART
              _HomeActionCard(
                icon: Icons.shopping_cart_outlined,
                title: "My Cart",
                subtitle: "View items in your cart",
                iconColor: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CartPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 26),

              // =================================================
              // MY ACCOUNT SECTION
              // =================================================
              const Text(
                "My Account",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),

              const SizedBox(height: 14),

              // =================================================
              // TWO COLUMN CARDS
              // =================================================
              LayoutBuilder(
                builder: (context, constraints) {
                  final cardWidth =
                      (constraints.maxWidth - 12) / 2;

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      // ORDERS
                      _SmallActionCard(
                        width: cardWidth,
                        icon: Icons.receipt_long_outlined,
                        title: "My Orders",
                        iconColor: Colors.blue,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderListPage(),
                            ),
                          );
                        },
                      ),

                      // WISHLIST
                      _SmallActionCard(
                        width: cardWidth,
                        icon: Icons.favorite_border,
                        title: "Wishlist",
                        iconColor: Colors.red,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WishlistPage(),
                            ),
                          );
                        },
                      ),

                      // PAYMENTS
                      _SmallActionCard(
                        width: cardWidth,
                        icon: Icons.payments_outlined,
                        title: "Payments",
                        iconColor: Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaymentListPage(),
                            ),
                          );
                        },
                      ),

                      // CART
                      _SmallActionCard(
                        width: cardWidth,
                        icon: Icons.shopping_cart_outlined,
                        title: "Cart",
                        iconColor: Colors.orange,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CartPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 26),

              // =================================================
              // SHOPPING TIP
              // =================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                    color: Colors.deepPurple.withValues(alpha: 0.10),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.local_offer_outlined,
                      color: Colors.deepPurple,
                      size: 25,
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Happy Shopping!",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            "Explore products and find something you love.",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
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
}

//═══════════════════════════════════════════════════════════
// LARGE HOME ACTION CARD
// ═══════════════════════════════════════════════════════════

class _HomeActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final VoidCallback onTap;

  const _HomeActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(17),
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

              const SizedBox(width: 14),

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
    );
  }
}

//═══════════════════════════════════════════════════════════
// SMALL HOME ACTION CARD
// ═══════════════════════════════════════════════════════════

class _SmallActionCard extends StatelessWidget {
  final double width;
  final IconData icon;
  final String title;
  final Color iconColor;
  final VoidCallback onTap;

  const _SmallActionCard({
    required this.width,
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        child: InkWell(
          borderRadius: BorderRadius.circular(17),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 23,
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222222),
                  ),
                ),

                const SizedBox(height: 4),

                const Icon(
                  Icons.arrow_forward,
                  size: 16,
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