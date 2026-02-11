import 'package:flutter_framework/error/domain/object/failure.build.dart';
import 'package:flutter_framework/result/result.build.dart';
import 'package:currency/currency.dart';
import 'package:loan_calculator/src/domain/object/loan_application_form.build.dart';
import 'package:loan_calculator/src/domain/object/monthly_payment.build.dart';

abstract class LoanCalculatorRemoteDataSourceContract {
  ResultFuture<LoanApplicationForm, Failure> getLoanInfo({String? productId, String? applicationId});

  ResultFuture<Uri, Failure> getConditions();

  ResultFuture<dynamic, Failure> getPdfFile({required String link});

  ResultFuture<MonthlyPayment, Failure> getMonthlyPayment({
    required CurrencyAmount currentAmount,
    required int currentTerm,
    String? productId,
    String? applicationId,
  });
}
