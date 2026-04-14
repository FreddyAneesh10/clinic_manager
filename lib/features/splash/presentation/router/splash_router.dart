import 'package:go_router/go_router.dart';
import '../view/splash_view.dart';

class SplashRouter {
  static const String splash = '/';

  static List<RouteBase> routes = [
    GoRoute(
      path: splash,
      builder: (context, state) => const SplashView(),
    ),
  ];
}
