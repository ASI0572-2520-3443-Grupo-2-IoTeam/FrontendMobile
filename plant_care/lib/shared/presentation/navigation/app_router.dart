import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../dashboard/presentation/widgets/dashboard_view.dart';
import '../../../plants/presentation/plant_detail_view.dart';
import '../../../analytics/presentation/pages/analytics_view.dart';
import '../widgets/custom_bottom_navbar.dart';
import '../views/settings_view.dart';
import '../views/search_filter_view.dart';
import '../../../subscription/presentation/pages/subscription_view.dart';
import '../../../plants/presentation/widgets/myplants_view.dart';
import 'package:plant_care/iam/presentation/pages/login_page.dart';
import 'package:plant_care/iam/presentation/pages/register_page.dart';
import 'package:plant_care/shared/presentation/views/splash_view.dart';
import 'package:plant_care/community/presentation/screens/join_community_screen.dart';
import 'package:plant_care/community/presentation/screens/community_screen.dart';
import 'package:plant_care/profile/presentation/views/profile_view.dart';

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
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),

   
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) =>
          const DashboardView(), 
    ),
    GoRoute(
      path: '/myplants',
      name: 'myplants',
      builder: (context, state) => Scaffold(
        body: const MyPlantsView(),
        bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
      ),
    ),
    GoRoute(
      path: '/community',
      name: 'community_join',
      builder: (context, state) =>
          const JoinCommunityScreen(), 
    ),
    GoRoute(
      path: '/community/feed',
      name: 'community_feed',
      builder: (context, state) =>
          const CommunityScreen(), 
    ),
    GoRoute(
      path: '/analytics',
      name: 'analytics',
      builder: (context, state) => Scaffold(
        body: const AnalyticsView(),
        bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
      ),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) =>
          const SettingsView(), 
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileView(),
    ),
    
    GoRoute(
      path: '/plant/:id',
      name: 'plant_detail',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return Scaffold(
          body: PlantDetailView(plantId: id),
          bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
        );
      },
    ),

    
    GoRoute(
      path: '/search',
      name: 'searchFilter',
      builder: (context, state) => const SearchFilterView(),
    ),
    GoRoute(
      path: '/subscription',
      name: 'subscription',
      builder: (context, state) => const SubscriptionView(),
    ),
  ],
);
