
// 📁 model/address_model.dart
class AddressModel {
  final String id;
  final String fullName;
  final String phone;
  final String address;
  final String city;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.city,
    required this.isDefault,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['_id'] ?? map['id'] ?? "",
      fullName: map['fullName'] ?? "",
      phone: map['phone'] ?? "",
      address: map['address'] ?? "",
      city: map['city'] ?? "",
      isDefault: map['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "fullName": fullName,
      "phone": phone,
      "address": address,
      "city": city,
      "isDefault": isDefault,
    };
  }

  /// ✅ Order create karte waqt shippingAddress ek hi String chahiye hoti hai
  String toShippingString() {
    return "$fullName, $phone, $address, $city";
  }
}

