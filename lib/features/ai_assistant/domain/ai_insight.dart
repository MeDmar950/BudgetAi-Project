/// Represents an advisory AI insight or recommendation.
///
/// CRITICAL DOMAIN GUARDRAIL:
/// 1. AI is strictly advisory and cannot alter ledger records or mutate accounts directly.
/// 2. AI cannot claim to have moved money, cancelled a subscription, or paid a bill
///    unless an authorized third-party integration actually completed that action.
/// 3. Financial totals and balances must always be calculated by [BalanceCalculator],
///    never hallucinated or approximated by an LLM.
final class AiInsight {
  final String id;
  final String title;
  final String message;
  final DateTime generatedAt;
  final String? actionableCategory;

  const AiInsight({
    required this.id,
    required this.title,
    required this.message,
    required this.generatedAt,
    this.actionableCategory,
  });
}
