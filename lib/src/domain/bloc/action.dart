part of 'bloc.build.dart';

@freezed
sealed class LoanCalculatorAction with _$LoanCalculatorAction {
  const factory LoanCalculatorAction.proceed({required LoanCalculatorData loanCalculatorData}) =
      LoanCalculatorActionProceed;

  const factory LoanCalculatorAction.limitsLoaded({
    required CurrencyAmount minAmount,
    required CurrencyAmount maxAmount,
    CurrencyAmount? minIncome,
    CurrencyAmount? maxIncome,
  }) = LoanCalculatorActionLimitsLoaded;

  const factory LoanCalculatorAction.currencyAmountChanged(CurrencyAmount amount) =
      LoanCalculatorActionCurrencyAmountChanged;

  const factory LoanCalculatorAction.incomeAmountChanged(CurrencyAmount amount) =
      LoanCalculatorActionIncomeAmountChanged;

  const factory LoanCalculatorAction.documentRequested({required Document document}) =
      LoanCalculatorActionDocumentRequested;

  const factory LoanCalculatorAction.creditReportRequested({required Uri uri, required String title}) =
      LoanCalculatorActionCreditReportRequested;
}
