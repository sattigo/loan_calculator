part of 'bloc.build.dart';

@freezed
abstract class LoanCalculatorState with _$LoanCalculatorState {
  const factory LoanCalculatorState({
    Documents? documents,
    String? applicationId,
    @Default([]) List<LoanDuration> durations,
    LoanDuration? tempDuration,
    LoanDuration? currentDuration,
    CurrencyAmount? currentAmount,
    CurrencyAmount? minLimit,
    CurrencyAmount? maxLimit,
    CurrencyAmount? currentIncome,
    CurrencyAmount? minIncome,
    CurrencyAmount? maxIncome,
    CurrencyAmount? monthlyAmount,
    CurrencyAmount? totalAmount,
    Failure? monthlyFailure,
    Failure? limitsFailure,
    Failure? termsFailure,
    Failure? monthlyIncomeFailure,
    @Default(false) bool isLoading,
    @Default(false) bool isMonthlyAmountLoading,
    @Default(false) bool isMonthlyAmountExpanded,
  }) = _LoanCalculatorState;
}

extension LoanCalculatorStateX on LoanCalculatorState {
  bool get canProceed =>
      monthlyAmount != null &&
      monthlyAmount?.amount != Decimal.zero &&
      minLimit != null &&
      maxLimit != null &&
      currentAmount != null &&
      currentAmount?.amount != Decimal.zero &&
      minLimit!.amount <= currentAmount!.amount &&
      maxLimit!.amount >= currentAmount!.amount &&
      (isIncomeFeatureEnabled && isIncomeFeatureValid || !isIncomeFeatureEnabled);

  bool get canExpandMonthlyPayment =>
      monthlyAmount != null &&
      minLimit != null &&
      maxLimit != null &&
      currentAmount != null &&
      monthlyAmount?.amount != Decimal.zero &&
      minLimit!.amount <= currentAmount!.amount &&
      maxLimit!.amount >= currentAmount!.amount;

  bool get isIncomeFeatureEnabled => minIncome != null && maxIncome != null;

  bool get isIncomeFeatureValid =>
      minIncome != null &&
      maxIncome != null &&
      currentIncome != null &&
      currentIncome?.amount != Decimal.zero &&
      minIncome!.amount <= currentIncome!.amount &&
      maxIncome!.amount >= currentIncome!.amount;
}
