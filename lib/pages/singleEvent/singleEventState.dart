import '../../business/models/article/event.dart';

class SingleEventState {
  final Event? event;
  final bool isLoading;

  SingleEventState({
    this.event,
    this.isLoading = false,
  });

  SingleEventState copyWith({
    Event? event,
    bool? isLoading,
  }) {
    return SingleEventState(
      event: event ?? this.event,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
