import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:currency/currency.dart';

part 'currency_amount_limits.build.freezed.dart';

@freezed
abstract class CurrencyAmountLimits with _$CurrencyAmountLimits {
  const factory CurrencyAmountLimits({required CurrencyAmount minAmount, required CurrencyAmount maxAmount}) =
      _CurrencyAmountLimits;
}
