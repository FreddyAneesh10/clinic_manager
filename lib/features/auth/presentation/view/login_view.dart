import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/labeled_field.dart';
import '../../../../core/widgets/form_action_button.dart';
import '../../auth_providers.dart';
import '../presenter/auth_state.dart';
import '../../../doctor/presentation/router/doctor_router.dart';
import '../../../receptionist/presentation/router/receptionist_router.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateUsername(String? value) => value?.isEmpty ?? true ? 'Required' : null;
  String? _validatePassword(String? value) => value?.isEmpty ?? true ? 'Required' : null;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authProvider.notifier).login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success && mounted) {
      final user = ref.read(authProvider).user;
      if (user?.role == 'receptionist') {
        context.go(ReceptionistRouter.dashboard);
      } else if (user?.role == 'doctor') {
        context.go(DoctorRouter.dashboard);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        showAppDialog(context: context, title: 'Login Error', message: next.error!, type: DialogType.error);
      }
    });

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _LoginHeader(),
                      const SizedBox(height: 32),
                      LabeledField(
                        label: 'Username',
                        child: CustomTextField(
                          controller: _usernameController,
                          hintText: 'Enter your username...',
                          prefixIcon: const Icon(Icons.person_outline),
                          validator: _validateUsername,
                        ),
                      ),
                      const SizedBox(height: 16),
                      LabeledField(
                        label: 'Password',
                        child: CustomTextField(
                          controller: _passwordController,
                          obscureText: true,
                          hintText: 'Enter your password...',
                          prefixIcon: const Icon(Icons.lock_outline),
                          validator: _validatePassword,
                        ),
                      ),
                      const SizedBox(height: 32),
                      FormActionButton(
                        isLoading: authState.isLoading,
                        label: 'Login',
                        alignment: Alignment.center,
                        onAction: _handleLogin,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.local_hospital, size: 48, color: AppColors.primary),
        ),
        const SizedBox(height: 24),
        Text('Mini Clinic Manager', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text('Please login to your account', style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
      ],
    );
  }
}
