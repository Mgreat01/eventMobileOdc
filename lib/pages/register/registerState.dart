import '../../business/models/user/interet.dart';
import '../../business/models/user/user.dart';

class RegisterState {
  final bool isLoading;
  final String? error;
  final User? user;

  final List<Interet> allInteretsFull;
  final List<int> selectedInterestIds;

  const RegisterState({
    this.isLoading = false,
    this.error,
    this.user,
    this.allInteretsFull = const [],
    this.selectedInterestIds = const [],
  });

  RegisterState copyWith({
    bool? isLoading,
    String? error,
    User? user,
    List<Interet>? allInteretsFull,
    List<int>? selectedInterestIds,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      user: user ?? this.user,
      allInteretsFull: allInteretsFull ?? this.allInteretsFull,
      selectedInterestIds: selectedInterestIds ?? this.selectedInterestIds,
    );
  }
}
