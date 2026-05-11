import 'package:go_router/go_router.dart';
import 'package:guess_it/features/auth/presentation/pages/login_page.dart';
import 'package:guess_it/features/auth/presentation/pages/register_page.dart';
import 'package:guess_it/features/hub/presentation/pages/hub_page.dart';
import 'package:guess_it/features/game/presentation/pages/game_setup_page.dart';
import 'package:guess_it/features/game/presentation/pages/custom_words_page.dart';
import 'package:guess_it/features/game/presentation/pages/game_play_page.dart';
import 'package:guess_it/features/game/presentation/pages/scoreboard_page.dart';
import 'package:guess_it/features/ranking/presentation/pages/ranking_page.dart';
import 'package:guess_it/features/hub/presentation/pages/how_to_play_page.dart';
import 'package:guess_it/features/auth/presentation/pages/profile_page.dart';
import 'package:guess_it/features/groups/presentation/pages/groups_page.dart';
import 'package:guess_it/features/groups/presentation/pages/group_details_page.dart';
import 'package:guess_it/features/groups/domain/entities/group_entity.dart';
import 'package:guess_it/features/game/domain/entities/team_entity.dart';

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
        return CustomWordsPage(
          initialTeams: setupData['initialTeams'] as List<TeamEntity>,
          targetCount: setupData['targetCount'] as int,
          hostTeamName: setupData['hostTeamName'] as String,
          turnDurationSeconds: setupData['turnDurationSeconds'] as int,
        );
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
    GoRoute(
      path: '/ranking',
      builder: (context, state) {
        return const RankingPage();
      },
    ),
    GoRoute(
      path: '/how-to-play',
      builder: (context, state) {
        return const HowToPlayPage();
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) {
        return const ProfilePage();
      },
    ),
    GoRoute(
      path: '/groups',
      builder: (context, state) {
        return const GroupsPage();
      },
    ),
    GoRoute(
      path: '/group-details',
      builder: (context, state) {
        return GroupDetailsPage(group: state.extra as GroupEntity);
      },
    ),
  ],
);
