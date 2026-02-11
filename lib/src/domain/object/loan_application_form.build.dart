import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loan_calculator/src/domain/object/loan_application_form_fields.build.dart';
import 'package:loan_calculator/src/domain/object/loan_application_form_validations.build.dart';

part 'loan_application_form.build.freezed.dart';

@freezed
abstract class LoanApplicationForm with _$LoanApplicationForm {
  const factory LoanApplicationForm({
    required LoanApplicationFormFields fields,
    required LoanApplicationFormValidations validations,
  }) = _LoanApplicationForm;
}
