import '../../business/models/article/category.dart';
import '../../business/models/article/event.dart';
import '../../business/models/user/interet.dart';

class HomeEventState {
  final List<Event>? latestEvents;
  final List<Interet>? interets;
  final bool isLoading;

  HomeEventState({
    this.latestEvents,
    this.interets,
    this.isLoading = false,
  });

  HomeEventState copyWith({
    List<Event>? latestEvents,
    List<Interet>? interets,
    bool? isLoading,
  }) {
    return HomeEventState(
      latestEvents: latestEvents ?? this.latestEvents,
      interets: interets ?? this.interets,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
