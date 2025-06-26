class RegisterRequest {
  String name;
  String email;
  String password;
  String passwordConfirmation;
  String role;

  // Champs spécifiques
  String? nomOrganis; // Pour les organisateurs
  List<int>? interets; // Pour les publics

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.role,
    this.nomOrganis,
    this.interets,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'role': role,
    };

    // Ajoute le champ seulement si ce sont des cas spécifiques
    if (nomOrganis != null && role == 'organisateur') {
      data['nom_organis'] = nomOrganis;
    }

    if (interets != null && role == 'public') {
      data['interets'] = interets;
    }

    return data;
  }
}
