part of 'bloc.build.dart';

@freezed
sealed class LoanCalculatorEvent with _$LoanCalculatorEvent {
  const factory LoanCalculatorEvent.loadLoanInfo({LoanCalculatorData? loanCalculatorData}) =
      _LoanCalculatorEventLoadLoanInfo;

  const factory LoanCalculatorEvent.loadConditions() = _LoanCalculatorEventLoadConditions;

  const factory LoanCalculatorEvent.currencyAmountChanged({required CurrencyAmount? amount}) =
      _LoanCalculatorEventCurrencyAmountChanged;

  const factory LoanCalculatorEvent.incomeAmountChanged({required CurrencyAmount? amount}) =
      _LoanCalculatorEventIncomeAmountChanged;

  const factory LoanCalculatorEvent.currencyAmountEditingCompleted() =
      _LoanCalculatorEventCurrencyAmountEditingCompleted;

  const factory LoanCalculatorEvent.durationChangeStarted({required LoanDuration duration}) =
      _LoanCalculatorEventDurationChangeStarted;

  const factory LoanCalculatorEvent.durationChangeEnded() = _LoanCalculatorEventDurationChangeEnded;

  const factory LoanCalculatorEvent.proceed() = _LoanCalculatorEventProceed;

  const factory LoanCalculatorEvent.loadingChanged({required bool isLoading}) = _LoanCalculatorEventLoadingChanged;

  const factory LoanCalculatorEvent.toggleMonthlyPaymentExpansion() = _LoanCalculatorEventToggleMonthlyPaymentExpansion;

  const factory LoanCalculatorEvent.onDocumentTap({required Document document}) =
      _LoanCalculatorEventOnDocumentTap;
}
