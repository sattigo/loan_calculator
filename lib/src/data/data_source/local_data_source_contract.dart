import 'package:flutter_framework/error/domain/object/failure.build.dart';
import 'package:flutter_framework/result/result.build.dart';
import 'package:loan_calculator/src/domain/object/loan_application_form.build.dart';

abstract class LoanCalculatorLocalDataSourceContract {
  ResultFuture<LoanApplicationForm, Failure> getLoanApplicationForm();

  ResultFuture<void, Failure> setLoanApplicationForm(LoanApplicationForm? newLoanInfo);

  ResultFuture<bool, Failure> hasLoanApplicationForm();
}
