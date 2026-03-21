import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'features/appointment/domain/entities/appointment_entity.dart';
import 'features/patient/domain/entities/patient_entity.dart';
import 'features/doctor/domain/entities/prescription_entity.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(PatientEntityAdapter());
  Hive.registerAdapter(AppointmentEntityAdapter());
  Hive.registerAdapter(PrescriptionEntityAdapter());

  // Open Boxes
  await Hive.openBox<PatientEntity>('patients');
  await Hive.openBox<AppointmentEntity>('appointments');
  await Hive.openBox<PrescriptionEntity>('prescriptions');

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mini Clinic Manager',
      theme: AppTheme.light,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
