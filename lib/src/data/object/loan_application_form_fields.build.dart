import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:currency/currency.dart';
import 'package:loan_core_objects/loan_core_objects.dart';

part 'loan_application_form_fields.build.freezed.dart';

@freezed
abstract class LoanApplicationFormFields with _$LoanApplicationFormFields {
  const factory LoanApplicationFormFields({
    CurrencyAmount? defaultAmount,
    CurrencyAmount? defaultMonthlyIncome,
    LoanDuration? defaultDuration,
  }) = _LoanApplicationFormFields;
}
