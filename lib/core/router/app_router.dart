import 'package:go_router/go_router.dart';
import 'package:guess_it/features/auth/presentation/pages/login_page.dart';
import 'package:guess_it/features/auth/presentation/pages/register_page.dart';
import 'package:guess_it/features/hub/presentation/pages/hub_page.dart';
import 'package:guess_it/features/room/presentation/pages/waiting_room_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) {
        return const RegisterPage();
      },
    ),
    GoRoute(
      path: '/hub',
      builder: (context, state) {
        return const HubPage();
      },
    ),
    GoRoute(
      path: '/waiting-room',
      builder: (context, state) {
        return const WaitingRoomPage();
      },
    ),
  ],
);
