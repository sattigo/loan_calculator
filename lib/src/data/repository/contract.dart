import 'package:flutter_framework/error/domain/object/failure.build.dart';
import 'package:flutter_framework/result/result.build.dart';
import 'package:currency/currency.dart';
import 'package:documents/documents.dart';
import 'package:loan_calculator/src/domain/object/loan_application_form.build.dart';
import 'package:loan_calculator/src/domain/object/monthly_payment.build.dart';

abstract class LoanCalculatorRepositoryContract {
  ResultFuture<Documents, Failure> getDocuments({
    required String code,
    String? resourceType,
    String? resourceId,
    bool isAuthorized,
  });

  ResultFuture<LoanApplicationForm, Failure> getLoanApplicationForm({
    bool forceUpdate = false,
    String? productId,
    String? applicationId,
  });

  ResultFuture<MonthlyPayment, Failure> getMonthlyPayment({
    required CurrencyAmount currentAmount,
    required int currentTerm,
    String? productId,
    String? applicationId,
  });

  ResultFuture<dynamic, Failure> getPdfFile({required String link});

  Future<void> datePickScreenContinueButtonPressed({required CurrencyAmount amount});

  Future<void> proceed();

  Future<void> sendAmountBelowMin();

  Future<void> sendAmountAboveMax();

  Future<void> durationChanged();

  Future<void> amountEditingCompleted();

  Future<void> monthlyPaymentPressed();

  Future<void> offerPressed();

  Future<void> creditRepostPressed();
}
