import 'package:go_router/go_router.dart';
import '../view/reception_dashboard_view.dart';
import '../view/add_appointment_view.dart';
import '../view/register_patient_view.dart';

class ReceptionistRouter {
  static const String dashboard = '/reception';
  static const String addAppointment = 'add-appointment';
  static const String registerPatient = 'register-patient';

  static List<RouteBase> routes = [
    GoRoute(
      path: dashboard,
      builder: (context, state) => const ReceptionDashboardView(),
      routes: [
        GoRoute(
          path: addAppointment,
          builder: (context, state) => const AddAppointmentView(),
        ),
        GoRoute(
          path: registerPatient,
          builder: (context, state) => const RegisterPatientView(),
        ),
      ],
    ),
  ];
}
