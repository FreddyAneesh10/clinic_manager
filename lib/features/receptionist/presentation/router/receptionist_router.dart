import 'package:go_router/go_router.dart';
import '../view/reception_dashboard_view.dart';
import '../view/register_patient_view.dart';
class ReceptionistRouter {
  static const String dashboard = '/reception';
  static const String registerPatient = 'register-patient';

  static List<RouteBase> routes = [
    GoRoute(
      path: dashboard,
      builder: (context, state) => const ReceptionDashboardView(),
      routes: [
        GoRoute(
          path: registerPatient,
          builder: (context, state) => const RegisterPatientView(),
        ),
      ],
    ),
  ];
}

