import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../interactor/login_interactor.dart';
import 'auth_state.dart';

class AuthPresenter extends StateNotifier<AuthState> {
  final LoginInteractor _loginInteractor;

  AuthPresenter(this._loginInteractor) : super(const AuthState());

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final user = await _loginInteractor.execute(username, password);
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
