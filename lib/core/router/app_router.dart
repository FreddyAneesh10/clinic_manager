import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/router/auth_router.dart';
import '../../features/doctor/presentation/router/doctor_router.dart';
import '../../features/receptionist/presentation/router/receptionist_router.dart';
import '../../features/appointment/presentation/router/appointment_router.dart';
import '../../features/patient/presentation/router/patient_router.dart';

import 'package:flutter/material.dart';
import '../../core/widgets/app_layout.dart';

import '../../core/widgets/layout_config.dart';

final appRouter = GoRouter(
  initialLocation: AuthRouter.login,
  routes: [
    ...AuthRouter.routes,
    ShellRoute(
      builder: (context, state, child) {
        final location = state.matchedLocation;
        final config = LayoutConfig.fromLocation(location);

        return AppLayout(
          key: const ValueKey('app_layout_shell'),
          currentRoute: location,
          sidebarItems: config.sidebarItems,
          title: config.title,
          subtitle: config.subtitle,
          pageTitle: config.pageTitle,
          onLogout: () => context.go(AuthRouter.login),
          child: child,
        );
      },
      routes: [
        ...ReceptionistRouter.routes,
        ...AppointmentRouter.routes,
        ...PatientRouter.routes,
        ...DoctorRouter.routes,
      ],
    ),
  ],
);

