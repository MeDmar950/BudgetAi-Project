import 'package:budget_ai/core/money/money.dart';

/// Represents a user financial account (e.g. Bank Account, Cash Wallet, Vodafone Cash, Instapay).
final class Account {
  final String id;
  final String name;
  final Money initialBalance;
  final DateTime createdAt;

  const Account({
    required this.id,
    required this.name,
    required this.initialBalance,
    required this.createdAt,
  });

  Account copyWith({
    String? id,
    String? name,
    Money? initialBalance,
    DateTime? createdAt,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      initialBalance: initialBalance ?? this.initialBalance,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Account && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
