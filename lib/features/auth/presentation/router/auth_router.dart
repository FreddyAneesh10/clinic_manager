import 'package:go_router/go_router.dart';
import '../view/login_view.dart';

class AuthRouter {
  static const String login = '/login';

  static List<RouteBase> routes = [
    GoRoute(
      path: login,
      builder: (context, state) => const LoginView(),
    ),
  ];
}
