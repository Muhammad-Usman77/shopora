
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopora/model/address_model.dart';
import 'package:shopora/user/provider/order_provider.dart';
import 'package:shopora/user/provider/cart_provider.dart';
import 'package:shopora/user/provider/payment_provider.dart';
import 'package:shopora/user/userviews/address_list_page.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  final double totalAmount;

  const CheckoutPage({super.key, required this.totalAmount});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  // State variable add karein
AddressModel? selectedAddress;

String selectedPaymentMethod = "COD";   // ✅ ADD KAREIN
// UI mein TextField ki jagah:

  // @override
  // void dispose() {
  //   addressController.dispose();
  //   super.dispose();
  // }

 void _handlePlaceOrder() {
  if (selectedAddress == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please select a shipping address")),
    );
    return;
  }

  ref.read(createOrderProvider.notifier).callApi(
        () => ref.read(orderRepositoryProvider).createOrder(
              shippingAddress: selectedAddress!.toShippingString(),
            ),
      );
}

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(createOrderProvider);

   ref.listen(createOrderProvider, (previous, next) {
  if (next.data != null && previous?.data == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Order Placed Successfully!")),
    );

    // ✅ Order create hone ke saath Payment bhi create karein
    final orderId = next.data!['data']['_id'];
    ref.read(createPaymentProvider.notifier).callApi(
          () => ref.read(paymentRepositoryProvider).createPayment(
                orderId: orderId,
                paymentMethod: selectedPaymentMethod,   // ✅ Ab dynamic hai
              ),
        );

    ref.read(cartListProvider.notifier).callApi(
          () => ref.read(cartRepositoryProvider).getCart(),
        );

    ref.read(createOrderProvider.notifier).reset();

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  if (next.error != null && previous?.error != next.error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(next.error!)),
    );
  }
});
       
    
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ✅ ORDER SUMMARY CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Order Total",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  Text(
                    "Rs. ${widget.totalAmount.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Shipping Address",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),
GestureDetector(
  onTap: () async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddressListPage(selectMode: true),
      ),
    );
    if (result != null && result is AddressModel) {
      setState(() => selectedAddress = result);
    }
  },
  child: Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: selectedAddress == null
        ? const Row(
            children: [
              Icon(Icons.add_location_alt_outlined, color: Colors.deepPurple),
              SizedBox(width: 10),
              Text("Tap to select delivery address"),
            ],
          )
        : Text(selectedAddress!.toShippingString()),
  ),
),
const SizedBox(height: 24),

const Text(
  "Payment Method",
  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
),

const SizedBox(height: 10),

Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Column(
    children: [
      RadioListTile<String>(
        value: "cod",
        groupValue: selectedPaymentMethod,
        title: const Text("Cash on Delivery"),
        onChanged: (val) => setState(() => selectedPaymentMethod = val!),
      ),
      RadioListTile<String>(
        value: "card",
        groupValue: selectedPaymentMethod,
        title: const Text("Credit/Debit Card"),
        onChanged: (val) => setState(() => selectedPaymentMethod = val!),
      ),
    ],
  ),
),
            const Spacer(),

            /// ✅ PLACE ORDER BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: orderState.isLoading ? null : _handlePlaceOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: orderState.isLoading
                    ? const SizedBox(
                        height: 21,
                        width: 21,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Place Order",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
