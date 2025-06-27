
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odc_mobile_template/business/models/user/user.dart';
import 'package:odc_mobile_template/business/models/user/interet.dart';
import 'package:odc_mobile_template/business/models/user/registerRequest.dart';
import 'package:odc_mobile_template/business/services/user/userLocalService.dart';
import 'package:odc_mobile_template/business/services/user/userNetworkService.dart';
import 'package:odc_mobile_template/pages/register/registerState.dart';
import 'dart:convert';
import '../../../main.dart';

class RegisterControl extends StateNotifier<RegisterState> {
  final UserNetworkService _networkService = getIt.get<UserNetworkService>();
  final UserLocalService _localService = getIt.get<UserLocalService>();

  RegisterControl() : super(RegisterState()) {
    loadInterets();
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
    String? organizationName,
    List<int>? interests,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final registerRequest = RegisterRequest(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        role: role,
        nomOrganis: organizationName,
        interets: interests,
      );

      final createdUser = await _networkService.creerCompte(registerRequest);
      await _localService.sauvegarderUser(createdUser);

      state = state.copyWith(isLoading: false, user: createdUser);
      return true;
    } catch (e) {
      String errorMessage = 'Erreur inconnue';

      try {
        final errorString = e.toString();
        if (errorString.contains('{')) {
          final jsonStart = errorString.indexOf('{');
          final json = errorString.substring(jsonStart);
          final Map<String, dynamic> parsed = jsonDecode(json);

          if (parsed.containsKey('errors')) {
            final errors = parsed['errors'] as Map<String, dynamic>;
            errorMessage = errors.entries
                .map((entry) => '${entry.key} : ${(entry.value as List).join(', ')}')
                .join('\n');
          } else if (parsed.containsKey('message')) {
            errorMessage = parsed['message'];
          }
        } else {
          errorMessage = errorString;
        }
      } catch (_) {
        errorMessage = e.toString();
      }

      state = state.copyWith(isLoading: false, error: errorMessage);
      return false;
    }
  }

  void toggleInterest(int interestId) {
    final current = List<int>.from(state.selectedInterestIds);
    if (current.contains(interestId)) {
      current.remove(interestId);
    } else if (current.length < 3) {
      current.add(interestId);
    }
    state = state.copyWith(selectedInterestIds: current);
  }

  Future<void> loadInterets() async {
    try {
      final interets = await _networkService.getInterets();
      state = state.copyWith(allInteretsFull: interets);
    } catch (e) {
      state = state.copyWith(
        error: 'Erreur lors du chargement des centres d\'intérêt',
      );
    }
  }
}

final registerControlProvider = StateNotifierProvider<RegisterControl, RegisterState>((ref) {
  ref.keepAlive();
  return RegisterControl();
});
