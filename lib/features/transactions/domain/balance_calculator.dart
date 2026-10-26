import 'package:budget_ai/core/money/currency.dart';
import 'package:budget_ai/core/money/money.dart';
import 'package:budget_ai/features/accounts/domain/account.dart';
import 'transaction.dart';

/// Summary of cash flow analytics for a given time window.
final class CashFlowSummary {
  final Money totalIncome;
  final Money totalExpense;
  final Money netSavings;
  final int transferCount;
  final Money totalTransferred;

  const CashFlowSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.netSavings,
    required this.transferCount,
    required this.totalTransferred,
  });
}

/// Pure deterministic calculation engine for account balances and cash flows.
///
/// CRITICAL FINANCIAL INVARIANTS:
/// 1. Transfers must NOT count as income or expense in aggregate analytics.
/// 2. Draft transactions (e.g. unconfirmed OCR receipts) do NOT affect balances or reports.
/// 3. Deleting or editing a transaction re-evaluates deterministic derived balances with zero drift.
abstract final class BalanceCalculator {
  /// Calculates the current balance of an account given its initial balance and transaction history.
  static Money calculateAccountBalance({
    required Account account,
    required Iterable<Transaction> transactions,
  }) {
    var balanceMinor = account.initialBalance.minorUnits;

    for (final tx in transactions) {
      if (tx.isDraft) continue; // Drafts do not affect live balances

      switch (tx.type) {
        case TransactionType.income:
          if (tx.accountId == account.id) {
            balanceMinor += tx.amount.minorUnits;
          }
          break;
        case TransactionType.expense:
          if (tx.accountId == account.id) {
            balanceMinor -= tx.amount.minorUnits;
          }
          break;
        case TransactionType.transfer:
          if (tx.accountId == account.id) {
            balanceMinor -= tx.amount.minorUnits;
          }
          if (tx.destinationAccountId == account.id) {
            balanceMinor += tx.amount.minorUnits;
          }
          break;
      }
    }

    return Money.fromMinorUnits(balanceMinor, account.initialBalance.currency);
  }

  /// Calculates total aggregate cash flow across all accounts.
  ///
  /// Guarantees that internal transfers between accounts are completely excluded
  /// from income and expense, preserving truthful cashflow analytics.
  static CashFlowSummary calculateCashFlow({
    required Iterable<Transaction> transactions,
    Currency currency = Currency.egp,
  }) {
    var incomeMinor = 0;
    var expenseMinor = 0;
    var transferredMinor = 0;
    var transferCount = 0;

    for (final tx in transactions) {
      if (tx.isDraft) continue;

      switch (tx.type) {
        case TransactionType.income:
          incomeMinor += tx.amount.minorUnits;
          break;
        case TransactionType.expense:
          expenseMinor += tx.amount.minorUnits;
          break;
        case TransactionType.transfer:
          // Invariant: Transfers are neither income nor expense!
          transferCount++;
          transferredMinor += tx.amount.minorUnits;
          break;
      }
    }

    final income = Money.fromMinorUnits(incomeMinor, currency);
    final expense = Money.fromMinorUnits(expenseMinor, currency);
    final net = income - expense;
    final transferred = Money.fromMinorUnits(transferredMinor, currency);

    return CashFlowSummary(
      totalIncome: income,
      totalExpense: expense,
      netSavings: net,
      transferCount: transferCount,
      totalTransferred: transferred,
    );
  }

  /// Calculates total net worth across all provided accounts and transactions.
  static Money calculateTotalNetWorth({
    required Iterable<Account> accounts,
    required Iterable<Transaction> transactions,
    Currency currency = Currency.egp,
  }) {
    var totalMinor = 0;
    for (final account in accounts) {
      final bal = calculateAccountBalance(
        account: account,
        transactions: transactions,
      );
      totalMinor += bal.minorUnits;
    }
    return Money.fromMinorUnits(totalMinor, currency);
  }
}
