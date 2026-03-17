import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/router/auth_router.dart';
import '../../features/doctor/presentation/router/doctor_router.dart';
import '../../features/receptionist/presentation/router/receptionist_router.dart';

final appRouter = GoRouter(
  initialLocation: AuthRouter.login,
  routes: [
    ...AuthRouter.routes,
    ...ReceptionistRouter.routes,
    ...DoctorRouter.routes,
  ],
);
