import '../../business/models/article/category.dart';
import '../../business/models/article/event.dart';

class HomeEventState {
  final List<Event>? latestEvents;
  final List<Category>? categories;
  final bool isLoading;

  HomeEventState({
    this.latestEvents,
    this.categories,
    this.isLoading = false,
  });

  HomeEventState copyWith({
    List<Event>? latestEvents,
    List <Category>? categories,
    bool? isLoading,
  }) {
    return HomeEventState(
      latestEvents: latestEvents ?? this.latestEvents,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
