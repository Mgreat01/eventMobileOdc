import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odc_mobile_template/pages/singleEvent/singleEventState.dart';
import '../../business/services/gestion/gestionNetworkService.dart';
import '../../main.dart';

class SingleEventController extends StateNotifier<SingleEventState> {
  final gestionNetwork = getIt.get<GestionNetworkService>();

  SingleEventController() : super(SingleEventState());

  Future<void> loadEventById(int? id) async {
    state = state.copyWith(isLoading: true);
    try {
      final event = await gestionNetwork.recuperEventById(id);
      state = state.copyWith(event: event, isLoading: false);
    } catch (e) {
      print("Erreur de chargement d'événement: $e");
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> favorite(int eventId, String token) async {
    var response =await gestionNetwork.favorite(eventId,token);
  }

  Future<void> subscribe(int eventId, String token) async {
    var response =await gestionNetwork.subscribe(eventId,token);
  }

}

final singleEventControllerProvider = StateNotifierProvider<SingleEventController, SingleEventState>((ref) {
  return SingleEventController();
});
