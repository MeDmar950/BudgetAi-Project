/// Authenticated user session representation.
final class UserSession {
  final String userId; // Authenticated user UID from auth provider
  final String email;
  final String? displayName;
  final DateTime? lastSignInAt;

  const UserSession({
    required this.userId,
    required this.email,
    this.displayName,
    this.lastSignInAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSession &&
          runtimeType == other.runtimeType &&
          userId == other.userId;

  @override
  int get hashCode => userId.hashCode;
}

/// Authentication and session contract.
abstract interface class AuthRepository {
  /// Stream of current authenticated session (null when unauthenticated).
  Stream<UserSession?> watchAuthState();

  /// Gets the currently authenticated user session or null.
  UserSession? get currentSession;

  /// Sign in with email and password.
  Future<UserSession> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign out current session.
  Future<void> signOut();
}
