
class Authentication {
  final String? email;
  final String? password;

  Authentication({this.email, this.password});

  factory Authentication.fromJson(Map<String, dynamic> json) => Authentication(
    email: json['email'],
    password: json['password'],
  );

  Map<String, dynamic> toJson() => {  // <-- Spécification explicite du type
    'email': email,
    'password': password,
  };
}