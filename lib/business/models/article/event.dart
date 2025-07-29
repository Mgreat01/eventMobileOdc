import 'category.dart';
import 'media.dart';
import '../user/User.dart';

class Event {
  final int id;
  final String? title;
  final String? description;
  final String? cycle;
  final List<Category>? categories;
  final User? createdBy;
  final Media? media;
  final String? dateTimeStart;
  final String? dateTimeEnd;
  final bool isFavorite;
  final bool isSubscribed;

  Event({
    required this.id,
    this.title,
    this.description,
    this.cycle,
    this.categories,
    this.createdBy,
    this.media,
    this.dateTimeStart,
    this.dateTimeEnd,
    this.isFavorite = false,
    this.isSubscribed = false,
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
      createdBy: json['created_by'] != null
          ? User.fromJson(json['created_by'])
          : null,
      media: json['media'] != null ? Media.fromJson(json['media']) : null,
      dateTimeStart: json['date_time_start'],
      dateTimeEnd: json['date_time_end'],
      isFavorite: json['favorite'] == '1',
      isSubscribed: json['subscribe'] == '1',
    );
  }
}
