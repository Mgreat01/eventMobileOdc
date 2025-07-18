import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odc_mobile_template/framework/user/userNetworkServiceImpl.dart';
import '../../business/services/user/userNetworkService.dart';
import '../../main.dart';
import '../../business/services/gestion/gestionNetworkService.dart';
import 'homeEventState.dart';

class HomeEventController extends StateNotifier<HomeEventState> {
  final gestionNetwork = getIt.get<GestionNetworkService>();
  final userNetwork = getIt.get<UserNetworkService>();

  HomeEventController() : super(HomeEventState()) {
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    state = state.copyWith(isLoading: true);
    try {
      final latest = await gestionNetwork.recupererDerniersEvents(3);
      final interets = await userNetwork.getInterets();
      state = state.copyWith(
        latestEvents: latest,
        interets: interets,
        isLoading: false,
      );
    } catch (e) {
      print('Erreur lors du chargement: $e');
      state = state.copyWith(isLoading: false);
    }
  }
}

final homeEventControllerProvider =
StateNotifierProvider<HomeEventController, HomeEventState>((ref) {
  return HomeEventController();
});
