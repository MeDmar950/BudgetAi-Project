import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../localization/l10n_extension.dart';
import '../theme/app_colors.dart';

class MainShellScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellScaffold({super.key, required this.navigationShell});

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primaryContainer,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: const Icon(
              Icons.account_balance_wallet,
              color: AppColors.primary,
            ),
            label: l10n.accounts,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(
              Icons.receipt_long,
              color: AppColors.primary,
            ),
            label: l10n.transactions,
          ),
          NavigationDestination(
            icon: const Icon(Icons.pie_chart_outline_rounded),
            selectedIcon: const Icon(
              Icons.pie_chart_rounded,
              color: AppColors.primary,
            ),
            label: l10n.budgets,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart, color: AppColors.primary),
            label: l10n.analytics,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings, color: AppColors.primary),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}
