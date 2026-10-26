import 'transaction.dart';

/// Contract for transaction data persistence and retrieval.
///
/// Implementations (e.g., Supabase Remote Datasource, Drift Local SQLite)
/// must enforce owner isolation and atomic database transactions.
abstract interface class TransactionRepository {
  /// Watches the stream of transactions for the authenticated user.
  Stream<List<Transaction>> watchTransactions({required String ownerId});

  /// Fetches all transactions for the authenticated user.
  Future<List<Transaction>> getTransactions({required String ownerId});

  /// Inserts a new transaction record.
  Future<void> createTransaction(Transaction transaction);

  /// Updates an existing transaction.
  Future<void> updateTransaction(Transaction transaction);

  /// Deletes a transaction by id.
  Future<void> deleteTransaction({required String id, required String ownerId});
}
