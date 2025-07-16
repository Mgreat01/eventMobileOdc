// otpVerificationState.dart

class OtpVerificationState {
  final bool isLoading;
  final bool isVerified;
  final String? error;
  final String? email;

  OtpVerificationState({
    this.isLoading = false,
    this.isVerified = false,
    this.error,
    this.email,
  });

  OtpVerificationState copyWith({
    bool? isLoading,
    bool? isVerified,
    String? error,
    String? email,
  }) {
    return OtpVerificationState(
      isLoading: isLoading ?? this.isLoading,
      isVerified: isVerified ?? this.isVerified,
      error: error,
      email: email ?? this.email,
    );
  }
}