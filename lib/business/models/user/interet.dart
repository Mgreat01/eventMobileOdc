class Interet {
  final int id;
  final String nom;

  Interet({required this.id, required this.nom});

  factory Interet.fromJson(Map<String, dynamic> json) {
    return Interet(
      id: json['id'],
      nom: json['nom'],
    );
  }
}
