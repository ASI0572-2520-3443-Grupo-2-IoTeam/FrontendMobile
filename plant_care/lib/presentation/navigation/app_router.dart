import 'package:go_router/go_router.dart';

// Importa las vistas que usaremos
import '../../analytics/presentation/pages/analytics_view.dart';
import '../../analytics/presentation/pages/reports_view.dart';
import '../../dashboard/presentation/widgets/dashboard_view.dart';
import '../../iam/presentation/widgets/login_view.dart';
import '../../iam/presentation/widgets/register_view.dart';
import '../../plant_detail/presentation/widgets/plant_detail_view.dart';
import '../views/search_filter_view.dart';
import '../views/settings_view.dart';
import '../views/splash_view.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterView(),
    ),
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardView(),
    ),
    /*GoRoute(
      path: '/myplants',
      name: 'myplants',
      builder: (context, state) => const MyPlantsView(),
    ),*/
    GoRoute(
      path: '/plant/:id',
      name: 'plantDetail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return PlantDetailView(plantId: id);
      },
    ),
    GoRoute(
      path: '/analytics',
      name: 'analytics',
      builder: (context, state) => const AnalyticsView(),
    ),
    GoRoute(
      path: '/reports',
      name: 'reports',
      builder: (context, state) => const ReportsView(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsView(),
    ),
    GoRoute(
      path: '/search',
      name: 'searchFilter',
      builder: (context, state) => const SearchFilterView(),
    ),
  ],
);
