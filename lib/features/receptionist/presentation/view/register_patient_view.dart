import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../patient/domain/entities/patient_entity.dart';
import '../../../../core/widgets/app_layout.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/responsive.dart';
import '../../receptionist_providers.dart';
import '../router/receptionist_router.dart';

class RegisterPatientView extends ConsumerStatefulWidget {
  const RegisterPatientView({super.key});

  @override
  ConsumerState<RegisterPatientView> createState() => _RegisterPatientViewState();
}

class _RegisterPatientViewState extends ConsumerState<RegisterPatientView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = _phoneController.text.trim();
    if (phone.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(phone)) {
      showAppDialog(
        context: context,
        title: 'Invalid Phone',
        message: 'Please enter a valid 10-digit phone number',
        type: DialogType.error,
      );
      return;
    }

    final patient = PatientEntity(
      id: const Uuid().v4(),
      name: _nameController.text.trim(),
      phone: phone,
    );

    final success = await ref.read(receptionistProvider.notifier).registerPatient(patient);

    if (success && mounted) {
      showAppDialog(
        context: context,
        title: 'Success',
        message: 'Patient registered successfully',
        type: DialogType.success,
        onConfirm: () => context.go(ReceptionistRouter.dashboard),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(receptionistProvider);

    ref.listen(receptionistProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        showAppDialog(
          context: context,
          title: 'Error',
          message: next.error!,
          type: DialogType.error,
        );
        ref.read(receptionistProvider.notifier).clearError();
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: AppCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Patient Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 24),

                  // Full Name
                  CustomTextField(
                    controller: _nameController,
                    labelText: 'Full Name',
                    hintText: 'e.g. John Doe',
                    prefixIcon: const Icon(Icons.person_outline),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),

                  // Phone Number
                  CustomTextField(
                    controller: _phoneController,
                    labelText: 'Phone Number',
                    hintText: 'e.g. +1 234 567 8900',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 32),

                  // Save Button
                  Align(
                    alignment: Responsive.isMobile(context)
                        ? Alignment.center
                        : Alignment.centerRight,
                    child: SizedBox(
                      width:
                          Responsive.isMobile(context) ? double.infinity : 200,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: state.isLoading ? null : _save,
                        child: state.isLoading
                            ? const Center(
                                child: SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2)))
                            : const Text('Register Patient'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
