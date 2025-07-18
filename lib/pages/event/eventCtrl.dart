import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odc_mobile_template/business/services/gestion/gestionNetworkService.dart';

import '../../main.dart';
import 'eventState.dart';


class EventController extends StateNotifier<EventState> {
  final eventNetwork = getIt.get<GestionNetworkService>();

  EventController() : super(EventState()) {
    recupererEvents();
  }

  Future<void> recupererEvents() async {
    state = state.copyWith(isLoading: true);
    final res = await eventNetwork.recupererEvents();
    print("Événements récupérés dans EventController: $res");
    state = state.copyWith(
      isLoading: false,
      allEvents: res,
      nouveauEvents: res,
    );
  }


  Future<void> rechercherEvent(String texte) async {
    state = state.copyWith(isLoading: true);

    if (texte.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        nouveauEvents: state.allEvents,
      );
      return;
    }

    final filtres = state.allEvents?.where((event) {
      return event.title?.toLowerCase().contains(texte.toLowerCase())?? false;
    }).toList();

    state = state.copyWith(
      isLoading: false,
      nouveauEvents: filtres,
    );
  }

  Future<void> filtrerParCategorie(int categorieId) async {
    state = state.copyWith(isLoading: true, categorieSelectionnee: categorieId);

    final filtres = state.allEvents?.where((event) {
      return event.categories?.any((cat) => cat.id == categorieId)?? false;
    }).toList();

    state = state.copyWith(
      isLoading: false,
      nouveauEvents: filtres,
    );
  }


}
final eventControllerProvider =
StateNotifierProvider<EventController, EventState>((ref) {
  return EventController();
});

final likerEventProvider =
StateNotifierProvider<EventController, EventState>((ref) {
  return EventController();
});
