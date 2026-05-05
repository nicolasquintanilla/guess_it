import 'package:go_router/go_router.dart';
import 'package:guess_it/features/auth/presentation/pages/login_page.dart';
import 'package:guess_it/features/auth/presentation/pages/register_page.dart';
import 'package:guess_it/features/hub/presentation/pages/hub_page.dart';
import 'package:guess_it/features/game/presentation/pages/game_setup_page.dart';
import 'package:guess_it/features/game/presentation/pages/custom_words_page.dart';
import 'package:guess_it/features/game/presentation/pages/game_play_page.dart';
import 'package:guess_it/features/game/presentation/pages/scoreboard_page.dart';

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
      path: '/game-setup',
      builder: (context, state) {
        return const GameSetupPage();
      },
    ),
    GoRoute(
      path: '/custom-words',
      builder: (context, state) {
        final Map<String, dynamic> setupData = state.extra as Map<String, dynamic>;
        return CustomWordsPage(setupData: setupData);
      },
    ),
    GoRoute(
      path: '/play',
      builder: (context, state) {
        return const GamePlayPage();
      },
    ),
    GoRoute(
      path: '/scoreboard',
      builder: (context, state) {
        return const ScoreboardPage();
      },
    ),
  ],
);
