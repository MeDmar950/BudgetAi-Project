import 'package:budget_ai/core/money/money.dart';

/// Supported financial transaction types.
enum TransactionType { income, expense, transfer }

/// Core financial transaction record in BudgetAI.
final class Transaction {
  final String id;
  final String ownerId; // Supabase auth.uid()
  final Money amount;
  final TransactionType type;
  final String accountId;
  final String?
  destinationAccountId; // Required if and only if type == transfer
  final String category;
  final String description;
  final DateTime dateTime;
  final bool isDraft; // True for OCR or AI drafts awaiting user review

  Transaction({
    required this.id,
    required this.ownerId,
    required this.amount,
    required this.type,
    required this.accountId,
    this.destinationAccountId,
    required this.category,
    this.description = '',
    required this.dateTime,
    this.isDraft = false,
  }) {
    if (!amount.isPositive) {
      throw ArgumentError('Transaction amount must be strictly positive');
    }
    if (type == TransactionType.transfer) {
      if (destinationAccountId == null || destinationAccountId!.isEmpty) {
        throw ArgumentError(
          'Transfers require a valid non-empty destinationAccountId',
        );
      }
      if (accountId == destinationAccountId) {
        throw ArgumentError(
          'Source accountId and destinationAccountId must not be the same account',
        );
      }
    } else {
      if (destinationAccountId != null) {
        throw ArgumentError(
          'Non-transfer transactions must not define destinationAccountId',
        );
      }
    }
  }

  Transaction copyWith({
    String? id,
    String? ownerId,
    Money? amount,
    TransactionType? type,
    String? accountId,
    String? destinationAccountId,
    String? category,
    String? description,
    DateTime? dateTime,
    bool? isDraft,
  }) {
    return Transaction(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      accountId: accountId ?? this.accountId,
      destinationAccountId: destinationAccountId ?? this.destinationAccountId,
      category: category ?? this.category,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      isDraft: isDraft ?? this.isDraft,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transaction &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
