import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:currency/currency.dart';

part 'monthly_payment.build.freezed.dart';

@freezed
abstract class MonthlyPayment with _$MonthlyPayment {
  const factory MonthlyPayment({required CurrencyAmount monthlyAmount, CurrencyAmount? totalAmount}) = _MonthlyPayment;
}
