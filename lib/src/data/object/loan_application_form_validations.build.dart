import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loan_calculator/src/domain/object/currency_amount_limits.build.dart';
import 'package:loan_core_objects/loan_core_objects.dart';

part 'loan_application_form_validations.build.freezed.dart';

@freezed
abstract class LoanApplicationFormValidations with _$LoanApplicationFormValidations {
  const factory LoanApplicationFormValidations({
    required CurrencyAmountLimits amount,
    required CurrencyAmountLimits? monthlyIncome,
    required List<LoanDuration> durations,
  }) = _LoanApplicationFormValidations;
}
