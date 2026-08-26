// ═══════════════════════════════════════════════════════════
// 📁 REUSABLE SAFE PROVIDER TEMPLATE
// Yeh template HAR project mein use ho sakta hai
// (Login, Signup, Cart, Order, Profile — sab ke liye)
// ═══════════════════════════════════════════════════════════

//import 'package:flutter_riverpod/flutter_riverpod.dart';

// ═══════════════════════════════════════════════════════════
// 🔹 STEP 1: Generic State Class (HAMESHA SAME RAHEGA)
// ═══════════════════════════════════════════════════════════
//
// Yeh class kisi bhi type ka data hold kar sakti hai
// <T> matlab "Type" jo hum baad mein decide karenge
// (Map, List, Model class — kuch bhi ho sakta hai)

class ApiState<T> {
  final bool isLoading;
  final String? error;
  final T? data;

  ApiState({
    this.isLoading = false,
    this.error,
    this.data,
  });

  // ✅ Naya state banane ke liye (kuch values change, baaqi same)
  ApiState<T> copyWith({
    bool? isLoading,
    String? error,
    T? data,
  }) {
    return ApiState<T>(
      isLoading: isLoading ?? this.isLoading,
      error: error, // ✅ error hamesha naya set hoga (purana clear ho)
      data: data ?? this.data,
    );
  }
}


// ═══════════════════════════════════════════════════════════
// 🔹 STEP 2: Generic StateNotifier (HAMESHA SAME RAHEGA)
// ═══════════════════════════════════════════════════════════
//
// Yeh class kisi bhi async function ko safely call karti hai
// Loading → Success/Error state khud manage karti hai
/*
class ApiNotifier<T> extends StateNotifier<ApiState<T>> {
  ApiNotifier() : super(ApiState<T>());

  // ✅ Yeh function har jagah reuse hoga
  // 'apiCall' woh function hai jo Repository se aayega
  Future<void> callApi(Future<T> Function() apiCall) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await apiCall();
      state = state.copyWith(isLoading: false, data: result);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll("Exception: ", ""),
      );
    }
  }

  // ✅ State reset karne ke liye (form clear karte waqt use hoga)
  void reset() {
    state = ApiState<T>();
  }
} 
*/


// ═══════════════════════════════════════════════════════════
// 🔹 STEP 3: Ab is template ko HAR feature ke liye use karein
// ═══════════════════════════════════════════════════════════

/*
─────────────────────────────────────────────
📌 EXAMPLE A: LOGIN PROVIDER (sirf yeh likhna hai)
─────────────────────────────────────────────

final loginProvider =
    StateNotifierProvider<ApiNotifier<Map<String, dynamic>>, ApiState<Map<String, dynamic>>>(
  (ref) => ApiNotifier<Map<String, dynamic>>(),
);

// UI mein call karna:
ref.read(loginProvider.notifier).callApi(
  () => ref.read(authRepositoryProvider).login(
        email: email,
        password: password,
      ),
);


─────────────────────────────────────────────
📌 EXAMPLE B: SIGNUP PROVIDER (sirf naam badla)
─────────────────────────────────────────────

final signupProvider =
    StateNotifierProvider<ApiNotifier<Map<String, dynamic>>, ApiState<Map<String, dynamic>>>(
  (ref) => ApiNotifier<Map<String, dynamic>>(),
);

// UI mein call karna:
ref.read(signupProvider.notifier).callApi(
  () => ref.read(authRepositoryProvider).signup(
        name: name,
        email: email,
        password: password,
      ),
);


─────────────────────────────────────────────
📌 EXAMPLE C: ADD TO CART PROVIDER
─────────────────────────────────────────────

final addToCartProvider =
    StateNotifierProvider<ApiNotifier<Map<String, dynamic>>, ApiState<Map<String, dynamic>>>(
  (ref) => ApiNotifier<Map<String, dynamic>>(),
);

// UI mein call karna:
ref.read(addToCartProvider.notifier).callApi(
  () => ref.read(cartRepositoryProvider).addToCart(
        productId: productId,
        quantity: quantity,
      ),
);


─────────────────────────────────────────────
📌 EXAMPLE D: GET PRODUCTS PROVIDER (List data)
─────────────────────────────────────────────

final productsProvider =
    StateNotifierProvider<ApiNotifier<List<dynamic>>, ApiState<List<dynamic>>>(
  (ref) => ApiNotifier<List<dynamic>>(),
);

// UI mein call karna:
ref.read(productsProvider.notifier).callApi(
  () => ref.read(productRepositoryProvider).getAllProducts(),
);

*/


// ═══════════════════════════════════════════════════════════
// 🔹 STEP 4: UI mein kaise use karein (Example)
// ═══════════════════════════════════════════════════════════

/*
class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // ✅ State watch karna (loading, error, data check karne ke liye)
    final state = ref.watch(loginProvider);

    // ✅ Success/Error listen karna (SnackBar, Navigation ke liye)
    ref.listen(loginProvider, (previous, next) {
      if (next.data != null && previous?.data == null) {
        // Login successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Successful!")),
        );
      }

      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    return ElevatedButton(
      onPressed: state.isLoading
          ? null
          : () {
              ref.read(loginProvider.notifier).callApi(
                () => ref.read(authRepositoryProvider).login(
                      email: emailController.text,
                      password: passwordController.text,
                    ),
              );
            },
      child: state.isLoading
          ? CircularProgressIndicator()
          : Text("Login"),
    );
  }
}
*/