

class User {
  int? id;
  String? name;
  String? email;
  String? role;

  // Spécifique à l'organisateur
  String? nomOrganis;

  // Spécifique au public
  List<int>? interets;

  // Optionnel : token d'authentification
  String? token;

  User({
    this.id,
    this.name,
    this.email,
    this.role,
    this.nomOrganis,
    this.interets,
    this.token
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> map = Map<String, dynamic>.from(json);
    return User(
      id: map['id'] as int?,
      name: map['name'] as String?,
      email: map['email'] as String?,
      role: map['role'] as String?,
      nomOrganis: map['nom_organis'] as String?,
      interets: map['interets'] != null
          ? List<int>.from(map['interets'])
          : null,
      token: map['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'email': email,
      'role': role,
    };

    if (nomOrganis != null) data['nom_organis'] = nomOrganis;
    if (interets != null) data['interets'] = interets;

    return data;
  }

  bool get isOrganisateur => role == 'organisateur';
  bool get isPublic => role == 'public';
}
