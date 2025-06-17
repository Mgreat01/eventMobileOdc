
class User {
  int? id;
  String? name;
  String? email;
  String? role;

  // Spécifique à l'organisateur
  String? nomOrganis;

  // Spécifique au public
  List<String>? interets;

  // Optionnel : token d'authentification
  String? token;

  User({
    this.id,
    this.name,
    this.email,
    this.role,
    this.nomOrganis,
    this.interets
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      nomOrganis: json['nom_organis'], // Pour l’organisateur
      interets: json['interets'] != null
          ? List<String>.from(json['interets'])
          : null, // Pour le public
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
