import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_layout.dart';
import '../../../receptionist/receptionist_providers.dart';

class PatientListView extends ConsumerStatefulWidget {
  const PatientListView({super.key});

  @override
  ConsumerState<PatientListView> createState() => _PatientListViewState();
}

class _PatientListViewState extends ConsumerState<PatientListView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(receptionistProvider.notifier).loadPatients());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(receptionistProvider);

    return state.isLoading && state.patients.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () =>
                ref.read(receptionistProvider.notifier).loadPatients(),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'All Patients',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Divider(height: 1),
                      if (state.patients.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(40),
                          child: Center(
                            child: Text(
                              'No patients registered yet.',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.patients.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final patient = state.patients[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.primaryLight
                                    .withValues(alpha: 0.2),
                                child: Text(
                                  patient.name.isNotEmpty
                                      ? patient.name[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                      color: AppColors.primaryDark,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(patient.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500)),
                              subtitle: Text(patient.phone,
                                  style: const TextStyle(
                                      color: AppColors.textSecondary)),
                              trailing: const Icon(Icons.chevron_right,
                                  color: AppColors.textSecondary),
                              onTap: () {
                                // Navigate to patient details if implemented
                              },
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
