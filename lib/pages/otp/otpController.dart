import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odc_mobile_template/pages/otp/otpState.dart';
import 'package:odc_mobile_template/business/services/user/userNetworkService.dart';
import 'package:odc_mobile_template/main.dart';

class OtpVerificationControl extends StateNotifier<OtpVerificationState> {
  final UserNetworkService _networkService = getIt.get<UserNetworkService>();

  OtpVerificationControl() : super(OtpVerificationState());

  void initEmail(String email) {
    state = state.copyWith(email: email);
  }

  Future<bool> verifyOtp(String otp) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final email = state.email;
      if (email == null) throw Exception('Email manquant');

      final isValid = await _networkService.verifierOtp(email: email, otp: otp);
      if (!isValid) throw Exception("Code incorrect ou expiré");

      state = state.copyWith(isLoading: false, isVerified: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isVerified: false,
      );
      return false;
    }
  }
}

final otpVerificationProvider = StateNotifierProvider<OtpVerificationControl, OtpVerificationState>(
      (ref) => OtpVerificationControl(),
);
