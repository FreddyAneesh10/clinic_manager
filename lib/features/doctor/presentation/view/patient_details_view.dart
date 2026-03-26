import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/patient_details_header.dart';
import '../../../../core/widgets/visit_details_card.dart';
import '../../../../core/widgets/action_card.dart';
import '../../../../core/widgets/prescription_history_section.dart';
import '../../doctor_providers.dart';
import '../router/doctor_router.dart';

class PatientDetailsView extends ConsumerWidget {
  const PatientDetailsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(doctorProvider);

    if (state.selectedPatient == null || state.selectedAppointment == null) {
      return Center(
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
      );
    }

    final patient = state.selectedPatient!;
    final appointment = state.selectedAppointment!;
    final prescriptions = state.patientPrescriptions;
    final isCompleted = appointment.status == 'completed';

    return state.isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  children: [
                    PatientDetailsHeader(
                      patientId: patient.id,
                      name: patient.name,
                      phone: patient.phone,
                      status: appointment.status,
                    ),
                    const SizedBox(height: 24),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              VisitDetailsCard(
                                time: appointment.time,
                                reason: appointment.reason,
                                isCompleted: isCompleted,
                              ),
                              const SizedBox(height: 24),
                              if (!isCompleted)
                                ActionCard(
                                  title: 'Diagnostic Required',
                                  description: 'Complete the visit by adding a prescription.',
                                  buttonLabel: 'Add Prescription',
                                  icon: Icons.medical_services_outlined,
                                  onAction: () => context.go('${DoctorRouter.dashboard}/${DoctorRouter.addPrescription}'),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 6,
                          child: PrescriptionHistorySection(
                            prescriptions: prescriptions.map((p) => PrescriptionItemData(
                              diagnosis: p.diagnosis,
                              dosage: p.dosage,
                              notes: p.notes,
                            )).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
