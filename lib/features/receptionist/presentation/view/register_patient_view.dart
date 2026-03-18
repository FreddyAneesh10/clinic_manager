import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/domain/entities/patient_entity.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_layout.dart';
import '../../../../core/widgets/app_sidebar.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/responsive.dart';
import '../../receptionist_providers.dart';
import '../router/receptionist_router.dart';
import '../../../appointment/presentation/router/appointment_router.dart';
import '../../../auth/presentation/router/auth_router.dart';

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

    final patient = PatientEntity(
      id: const Uuid().v4(),
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    final success = await ref.read(receptionistProvider.notifier).registerPatient(patient);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Patient registered successfully'), backgroundColor: AppColors.completed),
      );
      context.go(ReceptionistRouter.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(receptionistProvider);

    ref.listen(receptionistProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: AppColors.error),
        );
        ref.read(receptionistProvider.notifier).clearError();
      }
    });

    return AppLayout(
      currentRoute: '${ReceptionistRouter.dashboard}/${ReceptionistRouter.registerPatient}',
      pageTitle: 'Register New Patient',
      title: 'Mini Clinic',
      subtitle: 'Receptionist',
      onLogout: () => context.go(AuthRouter.login),
      sidebarItems: const [
        SidebarItem(label: 'Dashboard', icon: Icons.dashboard, route: ReceptionistRouter.dashboard),
        SidebarItem(label: 'Add Appointment', icon: Icons.calendar_today, route: AppointmentRouter.addAppointment),
        SidebarItem(label: 'Register Patient', icon: Icons.person_add, route: '${ReceptionistRouter.dashboard}/${ReceptionistRouter.registerPatient}'),
      ],
      child: SingleChildScrollView(
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
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    // Phone Number
                    CustomTextField(
                      controller: _phoneController,
                      labelText: 'Phone Number',
                      hintText: 'e.g. +1 234 567 8900',
                      prefixIcon: const Icon(Icons.phone_outlined),
                      keyboardType: TextInputType.phone,
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 32),
                    
                    // Save Button
                    Align(
                      alignment: Responsive.isMobile(context) ? Alignment.center : Alignment.centerRight,
                      child: SizedBox(
                        width: Responsive.isMobile(context) ? double.infinity : 200,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: state.isLoading ? null : _save,
                          child: state.isLoading
                              ? const Center(child: SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)))
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
      ),
    );
  }
}
