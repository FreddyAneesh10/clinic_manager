import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_layout.dart';
import '../../../../core/widgets/responsive.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../receptionist_providers.dart';
import '../../../appointment/appointment_providers.dart';

class ReceptionDashboardView extends ConsumerStatefulWidget {
  const ReceptionDashboardView({super.key});

  @override
  ConsumerState<ReceptionDashboardView> createState() => _ReceptionDashboardViewState();
}

class _ReceptionDashboardViewState extends ConsumerState<ReceptionDashboardView> {
  @override
  void initState() {
    super.initState();
    // Refresh data when screen loads
    Future.microtask(() {
      ref.read(receptionistProvider.notifier).loadPatients();
      ref.read(appointmentProvider.notifier).loadAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(receptionistProvider);
    final appointmentState = ref.watch(appointmentProvider);

    return (state.isLoading || appointmentState.isLoading) && appointmentState.appointments.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () async {
              await ref.read(receptionistProvider.notifier).loadPatients();
              await ref.read(appointmentProvider.notifier).loadAppointments();
            },
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // KPI Cards
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    StatCard(
                      title: 'Total Patients',
                      value: state.patients.length.toString(),
                      icon: Icons.people,
                      color: AppColors.primary,
                      width: Responsive.isMobile(context)
                          ? double.infinity
                          : (MediaQuery.of(context).size.width - 48 - 32) / 3,
                    ),
                    StatCard(
                      title: "Today's Appointments",
                      value: appointmentState.appointments.length.toString(),
                      icon: Icons.event,
                      color: AppColors.waiting,
                      width: Responsive.isMobile(context)
                          ? double.infinity
                          : (MediaQuery.of(context).size.width - 48 - 32) / 3,
                    ),
                    StatCard(
                      title: 'Completed',
                      value: appointmentState.appointments
                          .where((a) => a.status == 'completed')
                          .length
                          .toString(),
                      icon: Icons.check_circle,
                      color: AppColors.completed,
                      width: Responsive.isMobile(context)
                          ? double.infinity
                          : (MediaQuery.of(context).size.width - 48 - 32) / 3,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Appointments Table
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Today's Queue",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary),
                        ),
                      ),
                      const Divider(height: 1),
                      if (appointmentState.appointments.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(
                            child: Text(
                              'No appointments for today.',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                        )
                      else
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    minWidth: constraints.maxWidth),
                                child: DataTable(
                                  headingRowColor: WidgetStateProperty.all(
                                      AppColors.background),
                                  columnSpacing: 24,
                                  horizontalMargin: 20,
                                  columns: [
                                    const DataColumn(label: Text('Patient')),
                                    if (!Responsive.isMobile(context))
                                      const DataColumn(label: Text('Phone')),
                                    const DataColumn(label: Text('Time')),
                                    if (Responsive.isDesktop(context))
                                      const DataColumn(label: Text('Reason')),
                                    const DataColumn(label: Text('Status')),
                                  ],
                                  rows: appointmentState.appointments
                                      .map((appointment) {
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 16,
                                                backgroundColor: AppColors
                                                    .primaryLight
                                                    .withValues(alpha: 0.2),
                                                child: Text(
                                                  appointment.patientName
                                                          .isNotEmpty
                                                      ? appointment
                                                          .patientName[0]
                                                          .toUpperCase()
                                                      : '?',
                                                  style: const TextStyle(
                                                      color:
                                                          AppColors.primaryDark,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Text(appointment.patientName,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ],
                                          ),
                                        ),
                                        if (!Responsive.isMobile(context))
                                          DataCell(Text(appointment.phone,
                                              style: const TextStyle(
                                                  color: AppColors
                                                      .textSecondary))),
                                        DataCell(Text(appointment.time,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500))),
                                        if (Responsive.isDesktop(context))
                                          DataCell(Text(appointment.reason,
                                              style: const TextStyle(
                                                  color: AppColors
                                                      .textSecondary))),
                                        DataCell(StatusBadge(
                                            status: appointment.status)),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
