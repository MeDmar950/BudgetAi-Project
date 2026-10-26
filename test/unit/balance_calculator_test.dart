import 'package:flutter_test/flutter_test.dart';
import 'package:budget_ai/core/money/money.dart';
import 'package:budget_ai/features/accounts/domain/account.dart';
import 'package:budget_ai/features/transactions/domain/balance_calculator.dart';
import 'package:budget_ai/features/transactions/domain/transaction.dart';

void main() {
  group('BalanceCalculator and Financial Invariants', () {
    final now = DateTime(2026, 10, 26, 12, 0);

    final bankAccount = Account(
      id: 'acc_bank',
      name: 'CIB Bank',
      initialBalance: Money.fromMinorUnits(100000), // 1,000.00 EGP
      createdAt: now,
    );

    final cashWallet = Account(
      id: 'acc_cash',
      name: 'Cash Wallet',
      initialBalance: Money.fromMinorUnits(20000), // 200.00 EGP
      createdAt: now,
    );

    test('income increases account balance', () {
      final tx = Transaction(
        id: 'tx_1',
        ownerId: 'user_123',
        amount: Money.fromMinorUnits(50000), // 500.00 EGP
        type: TransactionType.income,
        accountId: bankAccount.id,
        category: 'Salary',
        dateTime: now,
      );

      final balance = BalanceCalculator.calculateAccountBalance(
        account: bankAccount,
        transactions: [tx],
      );

      // 1000 + 500 = 1500 EGP (150000 minor units)
      expect(balance.minorUnits, 150000);
    });

    test('expense decreases account balance', () {
      final tx = Transaction(
        id: 'tx_2',
        ownerId: 'user_123',
        amount: Money.fromMinorUnits(30000), // 300.00 EGP
        type: TransactionType.expense,
        accountId: bankAccount.id,
        category: 'Groceries',
        dateTime: now,
      );

      final balance = BalanceCalculator.calculateAccountBalance(
        account: bankAccount,
        transactions: [tx],
      );

      // 1000 - 300 = 700 EGP (70000 minor units)
      expect(balance.minorUnits, 70000);
    });

    test(
      'CRITICAL RULE: internal transfer does NOT count as income or expense in cashflow analytics',
      () {
        final transferTx = Transaction(
          id: 'tx_transfer',
          ownerId: 'user_123',
          amount: Money.fromMinorUnits(
            40000,
          ), // 400.00 EGP transfer from Bank to Cash
          type: TransactionType.transfer,
          accountId: bankAccount.id,
          destinationAccountId: cashWallet.id,
          category: 'ATM Withdrawal',
          dateTime: now,
        );

        final cashFlow = BalanceCalculator.calculateCashFlow(
          transactions: [transferTx],
        );

        // Invariant: transfer MUST NOT inflate income or expense
        expect(
          cashFlow.totalIncome.minorUnits,
          0,
          reason: 'Transfers must not count as income',
        );
        expect(
          cashFlow.totalExpense.minorUnits,
          0,
          reason: 'Transfers must not count as expense',
        );
        expect(cashFlow.netSavings.minorUnits, 0);
        expect(cashFlow.transferCount, 1);
        expect(cashFlow.totalTransferred.minorUnits, 40000);

        // But individual account balances must update correctly
        final bankBalance = BalanceCalculator.calculateAccountBalance(
          account: bankAccount,
          transactions: [transferTx],
        );
        final cashBalance = BalanceCalculator.calculateAccountBalance(
          account: cashWallet,
          transactions: [transferTx],
        );

        // Bank: 1000 - 400 = 600 EGP
        expect(bankBalance.minorUnits, 60000);
        // Cash: 200 + 400 = 600 EGP
        expect(cashBalance.minorUnits, 60000);

        // Total net worth remains unchanged
        final netWorth = BalanceCalculator.calculateTotalNetWorth(
          accounts: [bankAccount, cashWallet],
          transactions: [transferTx],
        );
        // Initial total: 1000 + 200 = 1200 EGP (120000 minor units)
        expect(netWorth.minorUnits, 120000);
      },
    );

    test(
      'CRITICAL RULE: draft transactions (OCR/AI) do not alter balances or analytics',
      () {
        final draftTx = Transaction(
          id: 'tx_draft',
          ownerId: 'user_123',
          amount: Money.fromMinorUnits(85000),
          type: TransactionType.expense,
          accountId: bankAccount.id,
          category: 'Scanned Supermarket Draft',
          dateTime: now,
          isDraft: true, // Pending user confirmation
        );

        final balance = BalanceCalculator.calculateAccountBalance(
          account: bankAccount,
          transactions: [draftTx],
        );
        final cashFlow = BalanceCalculator.calculateCashFlow(
          transactions: [draftTx],
        );

        // Draft must be completely ignored until confirmed
        expect(balance.minorUnits, bankAccount.initialBalance.minorUnits);
        expect(cashFlow.totalExpense.minorUnits, 0);
      },
    );

    test(
      'editing or deleting records produces deterministic totals without drift',
      () {
        final tx1 = Transaction(
          id: 'tx_1',
          ownerId: 'user_123',
          amount: Money.fromMinorUnits(20000), // +200 EGP
          type: TransactionType.income,
          accountId: bankAccount.id,
          category: 'Freelance',
          dateTime: now,
        );
        final tx2 = Transaction(
          id: 'tx_2',
          ownerId: 'user_123',
          amount: Money.fromMinorUnits(5000), // -50 EGP
          type: TransactionType.expense,
          accountId: bankAccount.id,
          category: 'Coffee',
          dateTime: now,
        );

        var transactions = [tx1, tx2];
        var balance = BalanceCalculator.calculateAccountBalance(
          account: bankAccount,
          transactions: transactions,
        );
        // 1000 + 200 - 50 = 1150 EGP (115000 minor units)
        expect(balance.minorUnits, 115000);

        // Simulate edit: update Coffee from 50 EGP to 60 EGP
        final updatedTx2 = tx2.copyWith(amount: Money.fromMinorUnits(6000));
        transactions = [tx1, updatedTx2];
        balance = BalanceCalculator.calculateAccountBalance(
          account: bankAccount,
          transactions: transactions,
        );
        // 1000 + 200 - 60 = 1140 EGP (114000 minor units)
        expect(balance.minorUnits, 114000);

        // Simulate deletion: delete tx1
        transactions = [updatedTx2];
        balance = BalanceCalculator.calculateAccountBalance(
          account: bankAccount,
          transactions: transactions,
        );
        // 1000 - 60 = 940 EGP (94000 minor units)
        expect(balance.minorUnits, 94000);
      },
    );

    test('validates transfer invariants', () {
      // Must fail if destinationAccountId is missing on transfer
      expect(
        () => Transaction(
          id: 'bad_tx',
          ownerId: 'user_123',
          amount: Money.fromMinorUnits(1000),
          type: TransactionType.transfer,
          accountId: 'acc_1',
          destinationAccountId: null,
          category: 'Transfer',
          dateTime: now,
        ),
        throwsArgumentError,
      );

      // Must fail if source and destination account are identical
      expect(
        () => Transaction(
          id: 'bad_tx_same',
          ownerId: 'user_123',
          amount: Money.fromMinorUnits(1000),
          type: TransactionType.transfer,
          accountId: 'acc_1',
          destinationAccountId: 'acc_1',
          category: 'Transfer',
          dateTime: now,
        ),
        throwsArgumentError,
      );

      // Must fail if non-transfer defines destinationAccountId
      expect(
        () => Transaction(
          id: 'bad_tx_income',
          ownerId: 'user_123',
          amount: Money.fromMinorUnits(1000),
          type: TransactionType.income,
          accountId: 'acc_1',
          destinationAccountId: 'acc_2',
          category: 'Salary',
          dateTime: now,
        ),
        throwsArgumentError,
      );
    });
  });
}
