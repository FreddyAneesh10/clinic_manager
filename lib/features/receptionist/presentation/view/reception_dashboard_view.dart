import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_layout.dart';
import '../../../../core/widgets/app_sidebar.dart';
import '../../receptionist_providers.dart';
import '../router/receptionist_router.dart';
import '../../../auth/presentation/router/auth_router.dart';

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
    Future.microtask(() => ref.read(receptionistProvider.notifier).loadDashboardData());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(receptionistProvider);

    return AppLayout(
      currentRoute: ReceptionistRouter.dashboard,
      pageTitle: 'Reception Dashboard',
      title: 'Mini Clinic',
      subtitle: 'Receptionist',
      onLogout: () => context.go(AuthRouter.login),
      sidebarItems: const [
        SidebarItem(label: 'Dashboard', icon: Icons.dashboard, route: ReceptionistRouter.dashboard),
        SidebarItem(label: 'Add Appointment', icon: Icons.calendar_today, route: '${ReceptionistRouter.dashboard}/${ReceptionistRouter.addAppointment}'),
      ],
      actions: [
        ElevatedButton.icon(
        onPressed: () => context.go('${ReceptionistRouter.dashboard}/${ReceptionistRouter.addAppointment}'),
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Add Appointment'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
        ),
      ],
      child: state.isLoading && state.appointments.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => ref.read(receptionistProvider.notifier).loadDashboardData(),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // KPI Cards
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Total Patients',
                          value: state.patients.length.toString(),
                          icon: Icons.people,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          title: "Today's Appointments",
                          value: state.appointments.length.toString(),
                          icon: Icons.event,
                          color: AppColors.waiting,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          title: 'Completed',
                          value: state.appointments.where((a) => a.status == 'completed').length.toString(),
                          icon: Icons.check_circle,
                          color: AppColors.completed,
                        ),
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
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          ),
                        ),
                        const Divider(height: 1),
                        if (state.appointments.isEmpty)
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
                                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                                  child: DataTable(
                                    headingRowColor: WidgetStateProperty.all(AppColors.background),
                                    columnSpacing: 24,
                                    horizontalMargin: 20,
                                    columns: const [
                                      DataColumn(label: Text('Patient')),
                                      DataColumn(label: Text('Phone')),
                                      DataColumn(label: Text('Time')),
                                      DataColumn(label: Text('Reason')),
                                      DataColumn(label: Text('Status')),
                                    ],
                                    rows: state.appointments.map((appointment) {
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 16,
                                                  backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
                                                  child: Text(
                                                    appointment.patientName.isNotEmpty ? appointment.patientName[0].toUpperCase() : '?',
                                                    style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 12),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Text(appointment.patientName, style: const TextStyle(fontWeight: FontWeight.w500)),
                                              ],
                                            ),
                                          ),
                                          DataCell(Text(appointment.phone, style: const TextStyle(color: AppColors.textSecondary))),
                                          DataCell(Text(appointment.time, style: const TextStyle(fontWeight: FontWeight.w500))),
                                          DataCell(Text(appointment.reason, style: const TextStyle(color: AppColors.textSecondary))),
                                          DataCell(StatusBadge(status: appointment.status)),
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
            ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
