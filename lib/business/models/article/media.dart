class Media {
  final int id;
  final String url;

  Media({required this.id, required this.url});

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'],
      url: json['url'],
    );
  }
}
