import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/accounts/presentation/accounts_screen.dart';
import '../../features/analytics/presentation/analytics_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/budgets/presentation/budgets_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/transactions/presentation/transactions_screen.dart';
import 'app_routes.dart';
import 'main_shell_scaffold.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

/// Builds the application GoRouter with stateful shell navigation for the 5 tabs
/// and top-level routes for auth and modals.
GoRouter createAppRouter({
  required VoidCallback onToggleLanguage,
  required Locale currentLocale,
}) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.accounts,
    debugLogDiagnostics: false,
    routes: [
      // 5-Tab Stateful Navigation Shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellScaffold(navigationShell: navigationShell);
        },
        branches: [
          // 0: Accounts / Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.accounts,
                builder: (context, state) => AccountsScreen(
                  onToggleLanguage: onToggleLanguage,
                  currentLocale: currentLocale,
                ),
              ),
            ],
          ),

          // 1: Transactions
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.transactions,
                builder: (context, state) => const TransactionsScreen(),
              ),
            ],
          ),

          // 2: Budgets
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.budgets,
                builder: (context, state) => const BudgetsScreen(),
              ),
            ],
          ),

          // 3: Analytics
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.analytics,
                builder: (context, state) => const AnalyticsScreen(),
              ),
            ],
          ),

          // 4: Settings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => SettingsScreen(
                  onToggleLanguage: onToggleLanguage,
                  currentLocale: currentLocale,
                ),
              ),
            ],
          ),
        ],
      ),

      // Auth & Modal Top-Level Routes (outside the bottom navigation shell)
      GoRoute(
        path: AppRoutes.login,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
  );
}
