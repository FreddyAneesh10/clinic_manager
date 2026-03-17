import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_layout.dart';
import '../../../../core/widgets/app_sidebar.dart';
import '../../doctor_providers.dart';
import '../router/doctor_router.dart';
import '../../../auth/presentation/router/auth_router.dart';

class DoctorDashboardView extends ConsumerStatefulWidget {
  const DoctorDashboardView({super.key});

  @override
  ConsumerState<DoctorDashboardView> createState() =>
      _DoctorDashboardViewState();
}

class _DoctorDashboardViewState extends ConsumerState<DoctorDashboardView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(doctorProvider.notifier).loadQueue());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(doctorProvider);

    return AppLayout(
      currentRoute: DoctorRouter.dashboard,
      pageTitle: 'Doctor Dashboard',
      title: 'Mini Clinic',
      subtitle: 'Doctor',
      onLogout: () => context.go(AuthRouter.login),
      sidebarItems: const [
        SidebarItem(
            label: 'Queue',
            icon: Icons.people_outline,
            route: DoctorRouter.dashboard),
      ],
      child: state.isLoading && state.queue.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => ref.read(doctorProvider.notifier).loadQueue(),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // KPI Cards
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Patients in Queue',
                          value: state.waitingCount.toString(),
                          icon: Icons.people,
                          color: AppColors.waiting,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          title: 'Total Appointments Today',
                          value: state.totalCount.toString(),
                          icon: Icons.event,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          title: 'Consultations Completed',
                          value: state.completedCount.toString(),
                          icon: Icons.check_circle,
                          color: AppColors.completed,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Queue Table
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
                        if (state.queue.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(40),
                            child: Center(
                              child: Text(
                                'Your queue is empty.',
                                style:
                                    TextStyle(color: AppColors.textSecondary),
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
                                    showCheckboxColumn: false,
                                    columns: const [
                                      DataColumn(label: Text('Time')),
                                      DataColumn(label: Text('Patient')),
                                      DataColumn(label: Text('Reason')),
                                      DataColumn(label: Text('Status')),
                                      DataColumn(label: Text('Action')),
                                    ],
                                    rows: state.queue.map((appointment) {
                                      final isCompleted =
                                          appointment.status == 'completed';
                                      return DataRow(
                                        onSelectChanged: (_) {
                                          ref
                                              .read(doctorProvider.notifier)
                                              .loadPatientDetails(appointment);
                                          context.go(
                                              '${DoctorRouter.dashboard}/${DoctorRouter.patientDetails}');
                                        },
                                        cells: [
                                          DataCell(Text(appointment.time,
                                              style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.w500))),
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
                                                        color: AppColors
                                                            .primaryDark,
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
                                          DataCell(Text(appointment.reason,
                                              style: const TextStyle(
                                                  color: AppColors
                                                      .textSecondary))),
                                          DataCell(StatusBadge(
                                              status: appointment.status)),
                                          DataCell(
                                            ElevatedButton(
                                              onPressed: () {
                                                ref
                                                    .read(
                                                        doctorProvider.notifier)
                                                    .loadPatientDetails(
                                                        appointment);
                                                context.go(
                                                    '${DoctorRouter.dashboard}/${DoctorRouter.patientDetails}');
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: isCompleted
                                                    ? AppColors.completed
                                                        .withValues(alpha: 0.1)
                                                    : AppColors.primary
                                                        .withValues(alpha: 0.1),
                                                foregroundColor: isCompleted
                                                    ? AppColors.completed
                                                    : AppColors.primary,
                                                elevation: 0,
                                              ),
                                              child: Text(isCompleted
                                                  ? 'View Record'
                                                  : 'Start Consultation'),
                                            ),
                                          ),
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
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
