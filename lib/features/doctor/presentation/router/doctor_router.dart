import 'package:go_router/go_router.dart';
import '../view/doctor_dashboard_view.dart';
import '../view/patient_details_view.dart';
import '../view/add_prescription_view.dart';

class DoctorRouter {
  static const String dashboard = '/doctor';
  static const String patientDetails = 'patient';
  static const String addPrescription = 'add-prescription';

  static List<RouteBase> routes = [
    GoRoute(
      path: dashboard,
      builder: (context, state) => const DoctorDashboardView(),
      routes: [
        GoRoute(
          path: patientDetails,
          builder: (context, state) => const PatientDetailsView(),
        ),
        GoRoute(
          path: addPrescription,
          builder: (context, state) => const AddPrescriptionView(),
        ),
      ],
    ),
  ];
}
