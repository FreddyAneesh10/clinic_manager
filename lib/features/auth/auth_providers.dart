import 'package:flutter_riverpod/flutter_riverpod.dart';

import './data/datasource/auth_datasource.dart';
import './data/datasource/auth_local_datasource.dart';
import './data/repository/auth_repository_impl.dart';
import './domain/repository/auth_repository.dart';
import 'interactor/login_interactor.dart';
import './presentation/presenter/auth_presenter.dart';
import './presentation/presenter/auth_state.dart';

// DataSource
final authLocalDataSourceProvider = Provider<IAuthDataSource>((ref) {
  return AuthLocalDataSource();
});

// Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authLocalDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
});

// Interactor (VIPER)
final loginInteractorProvider = Provider<LoginInteractor>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginInteractor(repository);
});

// Presenter (StateNotifierProvider)
final authProvider = StateNotifierProvider<AuthPresenter, AuthState>((ref) {
  final loginInteractor = ref.watch(loginInteractorProvider);
  return AuthPresenter(loginInteractor);
});
