
// 📁 ui/user/address_list_page.dart
// User apne saved addresses dekhe, add kare, select kare
// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopora/user/provider/address_provider.dart'; // apna sahi path

import 'package:shopora/user/userviews/address_page.dart';

class AddressListPage extends ConsumerStatefulWidget {
  /// ✅ Agar true ho, to address pe tap karne se woh "select" ho kar
  /// wapis Checkout page ko return ho jayega (Navigator.pop se)
  final bool selectMode;

  const AddressListPage({super.key, this.selectMode = false});

  @override
  ConsumerState<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends ConsumerState<AddressListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_fetchAddresses);
  }

  void _fetchAddresses() {
    ref.read(addressListProvider.notifier).callApi(
          () => ref.read(addressRepositoryProvider).getMyAddresses(),
        );
  }

  void _handleDelete(String id) {
    ref.read(deleteAddressProvider.notifier).callApi(
          () => ref.read(addressRepositoryProvider).deleteAddress(id),
        );
  }

  @override
  Widget build(BuildContext context) {
    final addressState = ref.watch(addressListProvider);
    final addresses = addressState.data ?? [];

    ref.listen(deleteAddressProvider, (previous, next) {
      if (next.data != null && previous?.data == null) {
        ref.read(deleteAddressProvider.notifier).reset();
        _fetchAddresses();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: Text(widget.selectMode ? "Select Address" : "My Addresses"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddAddressPage()),
          );
          _fetchAddresses();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: addressState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : addresses.isEmpty
              ? const Center(child: Text("No addresses saved yet"))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    final addr = addresses[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ListTile(
                        onTap: widget.selectMode
                            ? () => Navigator.pop(context, addr)
                            : null,
                        title: Text(
                          addr.fullName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "${addr.phone}\n${addr.address}, ${addr.city}",
                        ),
                        isThreeLine: true,
                        trailing: !widget.selectMode
                            ? IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red),
                                onPressed: () => _handleDelete(addr.id),
                              )
                            : addr.isDefault
                                ? const Icon(Icons.star,
                                    color: Colors.amber)
                                : null,
                      ),
                    );
                  },
                ),
    );
  }
}
