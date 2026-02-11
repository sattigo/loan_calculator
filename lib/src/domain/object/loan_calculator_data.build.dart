import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:currency/currency.dart';
import 'package:loan_core_objects/loan_core_objects.dart';

part 'loan_calculator_data.build.freezed.dart';

@freezed
abstract class LoanCalculatorData with _$LoanCalculatorData {
  const factory LoanCalculatorData({
    required CurrencyAmount amount,
    required LoanDuration duration,
    String? productId,
    String? applicationId,
    CurrencyAmount? income,
  }) = _LoanCalculatorData;
}
