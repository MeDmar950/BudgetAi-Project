import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/l10n_extension.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: Center(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                size: 64,
                color: AppColors.primary,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Welcome to BudgetAI',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Owned by Dev 3 — Supabase authentication, session handling, and OTP.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.accounts),
                child: const Text('Continue to App (Guest / Demo)'),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () => context.push(AppRoutes.register),
                child: const Text('Don\'t have an account? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
