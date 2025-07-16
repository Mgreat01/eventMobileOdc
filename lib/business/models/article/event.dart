import 'category.dart';
import 'media.dart';

class Event {
  final int id;
  final String? title;
  final String? description;
  final String? cycle;
  final List<Category>? categories;
  final Media? media;

  Event({
    required this.id,
    this.title,
    this.description,
    this.cycle,
    this.categories,
    this.media,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      cycle: json['cycle'],
      categories: (json['categories'] as List<dynamic>?)
          ?.map((cat) => Category.fromJson(cat))
          .toList(),
      media: json['media'] != null ? Media.fromJson(json['media']) : null,
    );
  }
}
