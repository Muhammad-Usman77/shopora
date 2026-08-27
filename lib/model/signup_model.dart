
class SignupModel {
  final String name;
  final String email;
  final String password;

  SignupModel({
    required this.name,
    required this.email,
    required this.password,
  });

  /// ✅ toMap - Object ko Map mein convert karna (API ko bhejne ke liye)
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "password": password,
    };
  }

  /// ✅ fromMap - Map ko Object mein convert karna (API se aane wala data)
  factory SignupModel.fromMap(Map<String, dynamic> map) {
    return SignupModel(
      name: map['name'] ?? "",
      email: map['email'] ?? "",
      password: map['password'] ?? "",
    );
  }

  /// ✅ copyWith - Kuch fields update karke naya object banana
  SignupModel copyWith({
    String? name,
    String? email,
    String? password,
  }) {
    return SignupModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'SignupModel(name: $name, email: $email, password: $password)';
  }
}