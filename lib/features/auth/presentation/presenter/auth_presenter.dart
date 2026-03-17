import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecase/login_usecase.dart';
import '../../../../core/domain/entities/user_entity.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final UserEntity? user;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    UserEntity? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error, // Can be null to clear error
      user: user ?? this.user,
    );
  }
}

class AuthPresenter extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;

  AuthPresenter(this._loginUseCase) : super(const AuthState());

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final user = await _loginUseCase.execute(username, password);
      state = state.copyWith(isLoading: false, user: user);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  void logout() {
    state = const AuthState();
  }
}
