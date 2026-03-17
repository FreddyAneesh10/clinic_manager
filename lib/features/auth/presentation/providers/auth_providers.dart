import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasource/auth_local_datasource.dart';
import '../../data/repository/auth_repository_impl.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/usecase/login_usecase.dart';
import '../presenter/auth_presenter.dart';

// DataSource
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSource();
});

// Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authLocalDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
});

// UseCase
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

// Presenter (StateNotifierProvider)
final authProvider = StateNotifierProvider<AuthPresenter, AuthState>((ref) {
  final loginUseCase = ref.watch(loginUseCaseProvider);
  return AuthPresenter(loginUseCase);
});
