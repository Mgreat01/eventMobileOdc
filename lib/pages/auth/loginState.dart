import '../../business/models/user/user.dart';

class LoginState {
  final bool isLoading;
  final bool isAutoLoginLoading;
  final String? errorMsg;
  final User? user;
  final bool rememberMe;

  LoginState({
    this.isLoading = false,
    this.isAutoLoginLoading = false,
    this.errorMsg,
    this.user,
    this.rememberMe = false,
  });

  LoginState copyWith({
    bool? isLoading,
    bool? isAutoLoginLoading,
    String? errorMsg,
    User? user,
    bool? rememberMe,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isAutoLoginLoading: isAutoLoginLoading ?? this.isAutoLoginLoading,
      errorMsg: errorMsg ?? this.errorMsg,
      user: user ?? this.user,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}
