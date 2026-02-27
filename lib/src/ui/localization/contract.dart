import 'package:flutter/widgets.dart';
import 'package:flutter_framework/base_localization/base_localization.dart';
import 'package:currency/currency.dart';
import 'package:ui_kit/ui_kit.dart';

abstract class LoanCalculatorLocalizationContract extends BaseLocalization {
  LoanCalculatorLocalizationContract({required this.currencyLocalization, required this.errorWidgetLocalization});

  final CurrencyLocalizationContract currencyLocalization;
  final ErrorWidgetLocalizationContract errorWidgetLocalization;

  String loanAmount(BuildContext context);

  String amountAtRate(BuildContext context);

  String mustBePaidBy({required BuildContext context, required String dateTime});

  String term(BuildContext context);

  String month(BuildContext context, int month);

  String monthlyPayment(BuildContext context);

  String monthlyPaymentDescription(BuildContext context);

  String monthlyPaymentDescriptionForReviewers({required BuildContext context, required String dateTime});

  String proceed(BuildContext context);

  String termsDescription(BuildContext context);

  String microloanOffer(BuildContext context);

  String and(BuildContext context);

  String creditReport(BuildContext context);

  String terms(BuildContext context);

  String unableToLoadInformation(BuildContext context);

  String sumError(BuildContext context);

  String tapToUpdate(BuildContext context);

  String total(BuildContext context);

  String loanTerms(BuildContext context);

  String yourMonthlyIncome(BuildContext context);

  String monthlyIncomeLoadingFailure(BuildContext context);
}
