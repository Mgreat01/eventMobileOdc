import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../business/models/user/authentication.dart';
import '../../business/services/user/userLocalService.dart';
import '../../business/services/user/userNetworkService.dart';
import '../../main.dart';
import 'loginState.dart';

class LoginControl extends StateNotifier<LoginState> {
  final UserNetworkService _networkService = getIt.get<UserNetworkService>();
  final UserLocalService _localService = getIt.get<UserLocalService>();

  LoginControl() : super(LoginState());

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMsg: null);
    try {
      final auth = Authentication(email: email, password: password);
      final user = await _networkService.seConnecter(auth);

      if (state.rememberMe) {
        await _localService.sauvegarderUser(user);
      }

      state = state.copyWith(isLoading: false, user: user);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMsg: 'Email ou mot de passe incorrect',
      );
      return false;
    }
  }

  void toggleRememberMe(bool value) {
    state = state.copyWith(rememberMe: value);
  }

  Future<bool> tryAutoLogin() async {
    state = state.copyWith(isAutoLoginLoading: true);
    try {
      final user = await _localService.recupererUser();
      if (user != null) {
        state = state.copyWith(isAutoLoginLoading: false, user: user);
        return true;
      }
      state = state.copyWith(isAutoLoginLoading: false);
      return false;
    } catch (e) {
      state = state.copyWith(isAutoLoginLoading: false);
      return false;
    }
  }

}


final loginControlProvider = StateNotifierProvider<LoginControl, LoginState>(
      (ref) {
    ref.keepAlive();
    return LoginControl();
  },
);
