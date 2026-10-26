import 'package:budget_ai/core/money/money.dart';
import 'package:budget_ai/features/transactions/domain/transaction.dart';

enum ReceiptDraftStatus { draft, confirmed, discarded }

/// Represents an OCR-extracted receipt draft.
///
/// Invariant: OCR output is strictly a draft and never alters user balances or
/// reports until the user reviews, modifies, and explicitly confirms it.
final class ReceiptDraft {
  final String id;
  final String ownerId;
  final String rawOcrText;
  final Money extractedAmount;
  final String? detectedMerchant;
  final DateTime detectedDate;
  final String? suggestedCategory;
  final ReceiptDraftStatus status;

  const ReceiptDraft({
    required this.id,
    required this.ownerId,
    required this.rawOcrText,
    required this.extractedAmount,
    this.detectedMerchant,
    required this.detectedDate,
    this.suggestedCategory,
    this.status = ReceiptDraftStatus.draft,
  });

  /// Converts a confirmed draft into a live financial transaction.
  /// Throws [StateError] if draft is not in confirmed state.
  Transaction toTransaction({
    required String accountId,
    required String confirmedCategory,
    required Money confirmedAmount,
  }) {
    if (status != ReceiptDraftStatus.confirmed) {
      throw StateError(
        'Cannot convert unconfirmed OCR draft to a live transaction.',
      );
    }

    return Transaction(
      id: id,
      ownerId: ownerId,
      amount: confirmedAmount,
      type: TransactionType.expense,
      accountId: accountId,
      category: confirmedCategory,
      description: detectedMerchant ?? 'Scanned receipt',
      dateTime: detectedDate,
      isDraft: false,
    );
  }
}
