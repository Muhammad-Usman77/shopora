
class LoginModel {
  final String email;
  final String password;

  LoginModel({
    required this.email,
    required this.password,
  });

  /// ✅ toMap - Object ko Map mein convert karna (API ko bhejne ke liye)
  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "password": password,
    };
  }

  /// ✅ fromMap - Map ko Object mein convert karna (API se aane wala data)
  factory LoginModel.fromMap(Map<String, dynamic> map) {
    return LoginModel(
      email: map['email'] ?? "",
      password: map['password'] ?? "",
    );
  }

  /// ✅ copyWith - Kuch fields update karke naya object banana
  LoginModel copyWith({
    String? email,
    String? password,
  }) {
    return LoginModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'LoginModel(email: $email, password: $password)';
  }
}
