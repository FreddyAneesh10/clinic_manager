import 'package:go_router/go_router.dart';
import '../view/patient_list_view.dart';

class PatientRouter {
  static const String root = '/reception/patients';

  static List<RouteBase> routes = [
    GoRoute(
      path: root,
      builder: (context, state) => const PatientListView(),
    ),
  ];
}
