import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_layout.dart';
import '../../../../core/widgets/app_sidebar.dart';
import '../providers/doctor_providers.dart';
import '../router/doctor_router.dart';
import '../../../auth/presentation/router/auth_router.dart';

class PatientDetailsView extends ConsumerWidget {
  const PatientDetailsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(doctorProvider);

    if (state.selectedPatient == null || state.selectedAppointment == null) {
      return AppLayout(
        currentRoute: '${DoctorRouter.dashboard}/${DoctorRouter.patientDetails}',
        pageTitle: 'Patient Details',
        title: 'Mini Clinic',
        subtitle: 'Doctor',
        onLogout: () => context.go(AuthRouter.login),
        sidebarItems: const [SidebarItem(label: 'Queue', icon: Icons.people_outline, route: DoctorRouter.dashboard)],
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('No patient selected'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go(DoctorRouter.dashboard),
                child: const Text('Back to Queue'),
              ),
            ],
          ),
        ),
      );
    }

    final patient = state.selectedPatient!;
    final appointment = state.selectedAppointment!;
    final prescriptions = state.patientPrescriptions;
    final isCompleted = appointment.status == 'completed';

    return AppLayout(
      currentRoute: '${DoctorRouter.dashboard}/${DoctorRouter.patientDetails}',
      pageTitle: 'Patient Case File',
      title: 'Mini Clinic',
      subtitle: 'Doctor',
      onLogout: () => context.go(AuthRouter.login),
      sidebarItems: const [
        SidebarItem(label: 'Queue', icon: Icons.people_outline, route: DoctorRouter.dashboard),
      ],
      child: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    children: [
                      // PERSISTENT HEADER CARD
                      _PatientHeader(patient: patient, appointment: appointment),
                      const SizedBox(height: 24),
                      
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // LEFT COLUMN - VISIT DETAILS
                          Expanded(
                            flex: 4,
                            child: Column(
                              children: [
                                _VisitDetailsCard(appointment: appointment, isCompleted: isCompleted),
                                const SizedBox(height: 24),
                                if (!isCompleted)
                                  _ActionCard(onAddPrescription: () => context.go('${DoctorRouter.dashboard}/${DoctorRouter.addPrescription}')),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          
                          // RIGHT COLUMN - PRESCRIPTION HISTORY
                          Expanded(
                            flex: 6,
                            child: _PrescriptionHistorySection(prescriptions: prescriptions),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class _PatientHeader extends StatelessWidget {
  final dynamic patient;
  final dynamic appointment;

  const _PatientHeader({required this.patient, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.sidebar,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Hero(
            tag: 'patient_${patient.id}',
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.sidebarActive.withValues(alpha: 0.2),
              child: Text(
                patient.name.isNotEmpty ? patient.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      patient.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    StatusBadge(status: appointment.status),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone_outlined, color: AppColors.sidebarText, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      patient.phone,
                      style: const TextStyle(color: AppColors.sidebarText, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VisitDetailsCard extends StatelessWidget {
  final dynamic appointment;
  final bool isCompleted;

  const _VisitDetailsCard({required this.appointment, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.event_note_outlined, color: AppColors.primary, size: 20),
              SizedBox(width: 12),
              Text(
                'VISIT INFORMATION',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.2,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1),
          ),
          _ModernInfoRow(
            icon: Icons.access_time,
            label: 'Scheduled Time',
            value: appointment.time,
          ),
          const SizedBox(height: 20),
          _ModernInfoRow(
            icon: Icons.medical_information_outlined,
            label: 'Reason for Visit',
            value: appointment.reason,
            isLongText: true,
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final VoidCallback onAddPrescription;

  const _ActionCard({required this.onAddPrescription});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.sidebarActive, AppColors.primaryLight],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            const Icon(Icons.medical_services_outlined, size: 32, color: AppColors.sidebarActive),
            const SizedBox(height: 12),
            const Text(
              'Diagnostic Required',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text(
              'Complete the visit by adding a prescription.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: onAddPrescription,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.sidebarActive,
                  elevation: 0,
                ),
                child: const Text('Add Prescription'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrescriptionHistorySection extends StatelessWidget {
  final List<dynamic> prescriptions;

  const _PrescriptionHistorySection({required this.prescriptions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Prescription History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${prescriptions.length} Records',
                style: const TextStyle(
                  color: AppColors.sidebarActive,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (prescriptions.isEmpty)
          AppCard(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(Icons.history_edu_outlined, size: 48, color: AppColors.textSecondary.withValues(alpha: 0.3)),
                    const SizedBox(height: 16),
                    const Text(
                      'No previous history available.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ...prescriptions.map((p) => _PrescriptionCard(prescription: p)),
      ],
    );
  }
}

class _PrescriptionCard extends StatelessWidget {
  final dynamic prescription;

  const _PrescriptionCard({required this.prescription});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.assignment_outlined, size: 16, color: AppColors.sidebarActive),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Diagnosis: ${prescription.diagnosis}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MEDICATIONS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  prescription.dosage,
                  style: const TextStyle(fontSize: 14, height: 1.5, fontWeight: FontWeight.w500),
                ),
                if (prescription.notes.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.lightbulb_outline, size: 14, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          prescription.notes,
                          style: const TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModernInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLongText;

  const _ModernInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLongText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: isLongText ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: AppColors.sidebarActive),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
