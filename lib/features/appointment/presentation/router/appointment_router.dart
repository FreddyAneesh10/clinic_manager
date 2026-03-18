import 'package:go_router/go_router.dart';
import '../view/add_appointment_view.dart';

class AppointmentRouter {
  static const String addAppointment = '/reception/add-appointment';

  static List<RouteBase> routes = [
    GoRoute(
      path: addAppointment,
      builder: (context, state) => const AddAppointmentView(),
    ),
  ];
}
