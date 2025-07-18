
import '../../business/models/article/category.dart';
import '../../business/models/article/event.dart';

class EventState {
  final List<Event>? allEvents;
  final List<Event>? nouveauEvents;
  final List<Category>? categories;
  final int? page;
  final String? recherche;
  final int? categorieSelectionnee;
  final bool? isLoading;

  EventState({
    this.allEvents,
    this.nouveauEvents,
    this.categories,
    this.page,
    this.recherche,
    this.categorieSelectionnee,
    this.isLoading,
  });

  EventState copyWith({
    List<Event>? allEvents,
    List<Event>? nouveauEvents,
    List<Category>? categories,
    int? page,
    String? recherche,
    int? categorieSelectionnee,
    bool? isLoading,
  }) {
    return EventState(
      allEvents: allEvents ?? this.allEvents,
      nouveauEvents: nouveauEvents ?? this.nouveauEvents,
      categories: categories ?? this.categories,
      page: page ?? this.page,
      recherche: recherche ?? this.recherche,
      categorieSelectionnee: categorieSelectionnee ?? this.categorieSelectionnee,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
