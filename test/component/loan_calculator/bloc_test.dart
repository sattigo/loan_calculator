import 'package:decimal/decimal.dart';
import 'package:flutter_framework/base_bloc_test/base_bloc_test.dart';
import 'package:flutter_framework/base_localization/base_localization.dart';
import 'package:flutter_framework/error/domain/object/failure.build.dart';
import 'package:flutter_framework/result/result.build.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:currency/currency.dart';
import 'package:documents/documents.dart';
import 'package:loan_calculator/src/data/repository/contract.dart';
import 'package:loan_calculator/src/domain/bloc/bloc.build.dart';
import 'package:loan_calculator/src/domain/object/currency_amount_limits.build.dart';
import 'package:loan_calculator/src/domain/object/loan_application_form.build.dart';
import 'package:loan_calculator/src/domain/object/loan_application_form_fields.build.dart';
import 'package:loan_calculator/src/domain/object/loan_application_form_validations.build.dart';
import 'package:loan_calculator/src/domain/object/loan_calculator_data.build.dart';
import 'package:loan_calculator/src/domain/object/monthly_payment.build.dart';
import 'package:loan_calculator/src/localization/contract.dart';
import 'package:loan_core_objects/loan_core_objects.dart';

class LoanCalculatorRepositoryMock extends Mock implements LoanCalculatorRepositoryContract {}

class LoanCalculatorLocalizationMock extends Mock implements LoanCalculatorLocalizationContract {}

// Необходимо для мокания Freezed-класса
// ignore: avoid_implementing_value_types
class LoanApplicationFormMock extends Mock implements LoanApplicationForm {}

// Необходимо для мокания Freezed-класса
// ignore: avoid_implementing_value_types
class LoanApplicationFormValidationsMock extends Mock implements LoanApplicationFormValidations {}

// Необходимо для мокания Freezed-класса
// ignore: avoid_implementing_value_types
class LoanApplicationFormFieldsMock extends Mock implements LoanApplicationFormFields {}

// Необходимо для мокания Freezed-класса
// ignore: avoid_implementing_value_types
class CurrencyAmountLimitsMock extends Mock implements CurrencyAmountLimits {}

// Необходимо для мокания Freezed-класса
// ignore: avoid_implementing_value_types
class LoanDurationMock extends Mock implements LoanDuration {}

// Необходимо для мокания Freezed-класса
// ignore: avoid_implementing_value_types
class MonthlyPaymentMock extends Mock implements MonthlyPayment {}

// Необходимо для мокания Freezed-класса
// ignore: avoid_implementing_value_types
class DocumentsMock extends Mock implements Documents {}

// Необходимо для мокания Freezed-класса
// ignore: avoid_implementing_value_types
class DocumentMock extends Mock implements Document {}

void main() {
  final repository = LoanCalculatorRepositoryMock();
  final localization = LoanCalculatorLocalizationMock();
  final form = LoanApplicationFormMock();
  final validations = LoanApplicationFormValidationsMock();
  final fields = LoanApplicationFormFieldsMock();
  final amountLimits = CurrencyAmountLimitsMock();
  final incomeLimits = CurrencyAmountLimitsMock();
  final duration = LoanDurationMock();
  final monthlyPayment = MonthlyPaymentMock();
  final documents = DocumentsMock();
  final document = DocumentMock();

  const documentsCode = 'test_documents_code';
  const productId = 'test_product_id';
  const applicationId = 'test_application_id';

  final minAmount = CurrencyAmount(amount: Decimal.fromInt(1000000), currency: CurrencyProvider.uzs);
  final maxAmount = CurrencyAmount(amount: Decimal.fromInt(50000000), currency: CurrencyProvider.uzs);
  final currentAmount = CurrencyAmount(amount: Decimal.fromInt(5000000), currency: CurrencyProvider.uzs);
  final minIncome = CurrencyAmount(amount: Decimal.fromInt(2000000), currency: CurrencyProvider.uzs);
  final maxIncome = CurrencyAmount(amount: Decimal.fromInt(100000000), currency: CurrencyProvider.uzs);
  final currentIncome = CurrencyAmount(amount: Decimal.fromInt(5000000), currency: CurrencyProvider.uzs);
  final monthlyAmount = CurrencyAmount(amount: Decimal.fromInt(500000), currency: CurrencyProvider.uzs);
  final totalAmount = CurrencyAmount(amount: Decimal.fromInt(6000000), currency: CurrencyProvider.uzs);

  const testDuration = LoanDuration(size: 12, unit: 'months');
  final testDurations = [testDuration];

  final testMonthlyPayment = MonthlyPayment(monthlyAmount: monthlyAmount, totalAmount: totalAmount);

  final testLoanCalculatorData = LoanCalculatorData(
    amount: currentAmount,
    duration: testDuration,
    income: currentIncome,
    productId: productId,
    applicationId: applicationId,
  );

  setUp(() {
    // Настройка моков для LoanApplicationForm
    when(() => form.validations).thenReturn(validations);
    when(() => form.fields).thenReturn(fields);

    // Настройка моков для validations
    when(() => validations.amount).thenReturn(amountLimits);
    when(() => validations.monthlyIncome).thenReturn(incomeLimits);
    when(() => validations.durations).thenReturn(testDurations);

    // Настройка моков для fields
    when(() => fields.defaultMonthlyIncome).thenReturn(currentIncome);

    // Настройка моков для amount limits
    when(() => amountLimits.minAmount).thenReturn(minAmount);
    when(() => amountLimits.maxAmount).thenReturn(maxAmount);

    // Настройка моков для income limits
    when(() => incomeLimits.minAmount).thenReturn(minIncome);
    when(() => incomeLimits.maxAmount).thenReturn(maxIncome);

    // Настройка моков для duration
    when(() => duration.size).thenReturn(12);
    when(() => duration.unit).thenReturn('months');

    // Настройка моков для monthlyPayment
    when(() => monthlyPayment.monthlyAmount).thenReturn(monthlyAmount);
    when(() => monthlyPayment.totalAmount).thenReturn(totalAmount);

    // Настройка моков для document
    when(() => document.private).thenReturn(false);
  });

  setUpAll(() {
    registerFallbackValue(CurrencyAmount(amount: Decimal.zero, currency: CurrencyProvider.uzs));
    // Базовые настройки репозитория
    when(
      () => repository.getLoanApplicationForm(
        productId: any(named: 'productId'),
        applicationId: any(named: 'applicationId'),
      ),
    ).thenAnswer((_) async => Result.success(form));

    when(
      () => repository.getMonthlyPayment(
        currentAmount: any(named: 'currentAmount'),
        currentTerm: any(named: 'currentTerm'),
        productId: any(named: 'productId'),
        applicationId: any(named: 'applicationId'),
      ),
    ).thenAnswer((_) async => Result.success(testMonthlyPayment));

    when(
      () => repository.getDocuments(
        code: any(named: 'code'),
        isAuthorized: any(named: 'isAuthorized'),
      ),
    ).thenAnswer((_) async => Result.success(documents));

    when(repository.proceed).thenAnswer((_) async {});
    when(repository.sendAmountBelowMin).thenAnswer((_) async {});
    when(repository.sendAmountAboveMax).thenAnswer((_) async {});
    when(repository.durationChanged).thenAnswer((_) async {});
    when(repository.amountEditingCompleted).thenAnswer((_) async {});
    when(repository.monthlyPaymentPressed).thenAnswer((_) async {});
  });

  group('LoanCalculatorBloc', () {
    baseBlocTest<LoanCalculatorBloc, LoanCalculatorEvent, LoanCalculatorState, LoanCalculatorAction, BaseLocalization>(
      'При инициализации блока состояние должно быть пустым',
      build: () => LoanCalculatorBloc(
        localization: localization,
        repository: repository,
        documentsCode: documentsCode,
        productId: productId,
      ),
      expect: () => <LoanCalculatorState>[],
      expectActions: () => <LoanCalculatorAction>[],
    );

    baseBlocTest<LoanCalculatorBloc, LoanCalculatorEvent, LoanCalculatorState, LoanCalculatorAction, BaseLocalization>(
      'При добавлении события loadLoanInfo должны загрузиться лимиты и эмиттиться соответствующие действия',
      build: () => LoanCalculatorBloc(
        localization: localization,
        repository: repository,
        documentsCode: documentsCode,
        productId: productId,
      ),
      act: (bloc) => bloc.add(const LoanCalculatorEvent.loadLoanInfo()),
      expect: () => <LoanCalculatorState>[
        const LoanCalculatorState(limitsFailure: null),
        LoanCalculatorState(
          limitsFailure: null,
          minLimit: minAmount,
          maxLimit: maxAmount,
          currentAmount: maxAmount,
          durations: testDurations,
          tempDuration: testDuration,
          currentDuration: testDuration,
          minIncome: minIncome,
          maxIncome: maxIncome,
          currentIncome: currentIncome,
        ),
        LoanCalculatorState(
          limitsFailure: null,
          minLimit: minAmount,
          maxLimit: maxAmount,
          currentAmount: maxAmount,
          durations: testDurations,
          tempDuration: testDuration,
          currentDuration: testDuration,
          minIncome: minIncome,
          maxIncome: maxIncome,
          currentIncome: currentIncome,
          isMonthlyAmountLoading: true,
        ),
        LoanCalculatorState(
          limitsFailure: null,
          minLimit: minAmount,
          maxLimit: maxAmount,
          currentAmount: maxAmount,
          durations: testDurations,
          tempDuration: testDuration,
          currentDuration: testDuration,
          minIncome: minIncome,
          maxIncome: maxIncome,
          currentIncome: currentIncome,
          monthlyAmount: monthlyAmount,
          totalAmount: totalAmount,
          isMonthlyAmountLoading: false,
        ),
      ],
      expectActions: () => <LoanCalculatorAction>[
        LoanCalculatorAction.limitsLoaded(
          minAmount: minAmount,
          maxAmount: maxAmount,
          minIncome: minIncome,
          maxIncome: maxIncome,
        ),
        LoanCalculatorAction.currencyAmountChanged(maxAmount),
        LoanCalculatorAction.incomeAmountChanged(currentIncome),
      ],
    );

    baseBlocTest<LoanCalculatorBloc, LoanCalculatorEvent, LoanCalculatorState, LoanCalculatorAction, BaseLocalization>(
      'При добавлении события loadLoanInfo с существующими данными должны использоваться переданные значения',
      build: () => LoanCalculatorBloc(
        localization: localization,
        repository: repository,
        documentsCode: documentsCode,
        productId: productId,
      ),
      act: (bloc) => bloc.add(LoanCalculatorEvent.loadLoanInfo(loanCalculatorData: testLoanCalculatorData)),
      expect: () => <LoanCalculatorState>[
        const LoanCalculatorState(limitsFailure: null, applicationId: applicationId),
        LoanCalculatorState(
          limitsFailure: null,
          applicationId: applicationId,
          minLimit: minAmount,
          maxLimit: maxAmount,
          currentAmount: currentAmount,
          durations: testDurations,
          tempDuration: testDuration,
          currentDuration: testDuration,
          minIncome: minIncome,
          maxIncome: maxIncome,
          currentIncome: currentIncome,
        ),
        LoanCalculatorState(
          limitsFailure: null,
          applicationId: applicationId,
          minLimit: minAmount,
          maxLimit: maxAmount,
          currentAmount: currentAmount,
          durations: testDurations,
          tempDuration: testDuration,
          currentDuration: testDuration,
          minIncome: minIncome,
          maxIncome: maxIncome,
          currentIncome: currentIncome,
          isMonthlyAmountLoading: true,
        ),
        LoanCalculatorState(
          limitsFailure: null,
          applicationId: applicationId,
          minLimit: minAmount,
          maxLimit: maxAmount,
          currentAmount: currentAmount,
          durations: testDurations,
          tempDuration: testDuration,
          currentDuration: testDuration,
          minIncome: minIncome,
          maxIncome: maxIncome,
          currentIncome: currentIncome,
          monthlyAmount: monthlyAmount,
          totalAmount: totalAmount,
          isMonthlyAmountLoading: false,
        ),
      ],
      expectActions: () => <LoanCalculatorAction>[
        LoanCalculatorAction.limitsLoaded(
          minAmount: minAmount,
          maxAmount: maxAmount,
          minIncome: minIncome,
          maxIncome: maxIncome,
        ),
        LoanCalculatorAction.currencyAmountChanged(currentAmount),
        LoanCalculatorAction.incomeAmountChanged(currentIncome),
      ],
    );

    baseBlocTest<LoanCalculatorBloc, LoanCalculatorEvent, LoanCalculatorState, LoanCalculatorAction, BaseLocalization>(
      'При ошибке загрузки лимитов должно устанавливаться состояние с ошибкой',
      setUp: () {
        when(
          () => repository.getLoanApplicationForm(
            productId: any(named: 'productId'),
            applicationId: any(named: 'applicationId'),
          ),
        ).thenAnswer((_) async => const Result.failure(Failure.general()));
      },
      build: () => LoanCalculatorBloc(
        localization: localization,
        repository: repository,
        documentsCode: documentsCode,
        productId: productId,
      ),
      act: (bloc) => bloc.add(const LoanCalculatorEvent.loadLoanInfo()),
      expect: () => <LoanCalculatorState>[
        const LoanCalculatorState(limitsFailure: null),
        const LoanCalculatorState(limitsFailure: Failure.general()),
      ],
      expectActions: () => <LoanCalculatorAction>[],
    );

    baseBlocTest<LoanCalculatorBloc, LoanCalculatorEvent, LoanCalculatorState, LoanCalculatorAction, BaseLocalization>(
      'При добавлении события proceed должно эмиттиться действие proceed с данными калькулятора',
      seed: () => LoanCalculatorState(
        currentAmount: currentAmount,
        currentDuration: testDuration,
        currentIncome: currentIncome,
      ),
      build: () => LoanCalculatorBloc(
        localization: localization,
        repository: repository,
        documentsCode: documentsCode,
        productId: productId,
      ),
      act: (bloc) => bloc.add(const LoanCalculatorEvent.proceed()),
      expect: () => <LoanCalculatorState>[],
      expectActions: () => <LoanCalculatorAction>[
        LoanCalculatorAction.proceed(
          loanCalculatorData: LoanCalculatorData(
            amount: currentAmount,
            duration: testDuration,
            income: currentIncome,
            productId: productId,
          ),
        ),
      ],
    );

    baseBlocTest<LoanCalculatorBloc, LoanCalculatorEvent, LoanCalculatorState, LoanCalculatorAction, BaseLocalization>(
      'При изменении суммы кредита должны пересчитываться ежемесячные платежи',
      seed: () => LoanCalculatorState(minLimit: minAmount, maxLimit: maxAmount, currentDuration: testDuration),
      build: () => LoanCalculatorBloc(
        localization: localization,
        repository: repository,
        documentsCode: documentsCode,
        productId: productId,
      ),
      act: (bloc) => bloc.add(LoanCalculatorEvent.currencyAmountChanged(amount: currentAmount)),
      wait: const Duration(milliseconds: 600),
      expect: () => <LoanCalculatorState>[
        LoanCalculatorState(
          minLimit: minAmount,
          maxLimit: maxAmount,
          currentDuration: testDuration,
          termsFailure: null,
          monthlyFailure: null,
          monthlyAmount: null,
          totalAmount: null,
          isMonthlyAmountLoading: true,
        ),
        LoanCalculatorState(
          minLimit: minAmount,
          maxLimit: maxAmount,
          currentDuration: testDuration,
          monthlyAmount: monthlyAmount,
          currentAmount: currentAmount,
          totalAmount: totalAmount,
          isMonthlyAmountLoading: false,
        ),
      ],
      expectActions: () => <LoanCalculatorAction>[],
    );

    baseBlocTest<LoanCalculatorBloc, LoanCalculatorEvent, LoanCalculatorState, LoanCalculatorAction, BaseLocalization>(
      'При изменении суммы кредита ниже минимального лимита должен вызываться соответствующий метод репозитория',
      seed: () => LoanCalculatorState(minLimit: minAmount, maxLimit: maxAmount, currentDuration: testDuration),
      build: () => LoanCalculatorBloc(
        localization: localization,
        repository: repository,
        documentsCode: documentsCode,
        productId: productId,
      ),
      act: (bloc) => bloc.add(
        LoanCalculatorEvent.currencyAmountChanged(
          amount: CurrencyAmount(amount: Decimal.fromInt(500000), currency: CurrencyProvider.uzs),
        ),
      ),
      wait: const Duration(milliseconds: 600),
      verify: (_) {
        verify(repository.sendAmountBelowMin).called(1);
      },
      expect: () => <LoanCalculatorState>[
        LoanCalculatorState(
          minLimit: minAmount,
          maxLimit: maxAmount,
          currentDuration: testDuration,
          currentAmount: CurrencyAmount(amount: Decimal.fromInt(500000), currency: CurrencyProvider.uzs),
          monthlyAmount: null,
        ),
      ],
      expectActions: () => <LoanCalculatorAction>[],
    );

    baseBlocTest<LoanCalculatorBloc, LoanCalculatorEvent, LoanCalculatorState, LoanCalculatorAction, BaseLocalization>(
      'При изменении суммы кредита выше максимального лимита должен вызываться соответствующий метод репозитория',
      seed: () => LoanCalculatorState(minLimit: minAmount, maxLimit: maxAmount, currentDuration: testDuration),
      build: () => LoanCalculatorBloc(
        localization: localization,
        repository: repository,
        documentsCode: documentsCode,
        productId: productId,
      ),
      act: (bloc) => bloc.add(
        LoanCalculatorEvent.currencyAmountChanged(
          amount: CurrencyAmount(amount: Decimal.fromInt(100000000), currency: CurrencyProvider.uzs),
        ),
      ),
      wait: const Duration(milliseconds: 600),
      verify: (_) {
        verify(repository.sendAmountAboveMax).called(1);
      },
      expect: () => <LoanCalculatorState>[
        LoanCalculatorState(
          minLimit: minAmount,
          maxLimit: maxAmount,
          currentDuration: testDuration,
          currentAmount: CurrencyAmount(amount: Decimal.fromInt(100000000), currency: CurrencyProvider.uzs),
          monthlyAmount: null,
        ),
      ],
      expectActions: () => <LoanCalculatorAction>[],
    );

    baseBlocTest<LoanCalculatorBloc, LoanCalculatorEvent, LoanCalculatorState, LoanCalculatorAction, BaseLocalization>(
      'При изменении дохода должно обновляться состояние',
      build: () => LoanCalculatorBloc(
        localization: localization,
        repository: repository,
        documentsCode: documentsCode,
        productId: productId,
      ),
      act: (bloc) => bloc.add(LoanCalculatorEvent.incomeAmountChanged(amount: currentIncome)),
      wait: const Duration(milliseconds: 600),
      expect: () => <LoanCalculatorState>[LoanCalculatorState(currentIncome: currentIncome)],
      expectActions: () => <LoanCalculatorAction>[],
    );

    baseBlocTest<LoanCalculatorBloc, LoanCalculatorEvent, LoanCalculatorState, LoanCalculatorAction, BaseLocalization>(
      'При изменении срока кредита должен устанавливаться временный срок',
      build: () => LoanCalculatorBloc(
        localization: localization,
        repository: repository,
        documentsCode: documentsCode,
        productId: productId,
      ),
      act: (bloc) => bloc.add(const LoanCalculatorEvent.durationChangeStarted(duration: testDuration)),
      expect: () => <LoanCalculatorState>[const LoanCalculatorState(tempDuration: testDuration)],
      expectActions: () => <LoanCalculatorAction>[],
    );

    baseBlocTest<LoanCalculatorBloc, LoanCalculatorEvent, LoanCalculatorState, LoanCalculatorAction, BaseLocalization>(
      'При завершении изменения срока должны пересчитываться ежемесячные платежи',
      seed: () => LoanCalculatorState(
        currentAmount: currentAmount,
        minLimit: minAmount,
        maxLimit: maxAmount,
        currentDuration: const LoanDuration(size: 6, unit: 'months'),
        tempDuration: testDuration,
      ),
      build: () => LoanCalculatorBloc(
        localization: localization,
        repository: repository,
        documentsCode: documentsCode,
        productId: productId,
      ),
      act: (bloc) => bloc.add(const LoanCalculatorEvent.durationChangeEnded()),
      expect: () => <LoanCalculatorState>[
        LoanCalculatorState(
          currentAmount: currentAmount,
          minLimit: minAmount,
          maxLimit: maxAmount,
          monthlyFailure: null,
          currentDuration: testDuration,
          tempDuration: testDuration,
          isMonthlyAmountLoading: true,
        ),
        LoanCalculatorState(
          currentAmount: currentAmount,
          minLimit: minAmount,
          maxLimit: maxAmount,
          monthlyAmount: monthlyAmount,
          totalAmount: totalAmount,
          currentDuration: testDuration,
          tempDuration: testDuration,
          isMonthlyAmountLoading: false,
        ),
      ],
      expectActions: () => <LoanCalculatorAction>[],
    );

    baseBlocTest<LoanCalculatorBloc, LoanCalculatorEvent, LoanCalculatorState, LoanCalculatorAction, BaseLocalization>(
      'При загрузке условий должны загружаться документы',
      build: () => LoanCalculatorBloc(
        localization: localization,
        repository: repository,
        documentsCode: documentsCode,
        productId: productId,
      ),
      act: (bloc) => bloc.add(const LoanCalculatorEvent.loadConditions()),
      expect: () => <LoanCalculatorState>[LoanCalculatorState(documents: documents)],
      expectActions: () => <LoanCalculatorAction>[],
    );

    baseBlocTest<LoanCalculatorBloc, LoanCalculatorEvent, LoanCalculatorState, LoanCalculatorAction, BaseLocalization>(
      'При ошибке загрузки условий должно устанавливаться состояние с ошибкой',
      setUp: () {
        when(
          () => repository.getDocuments(
            code: any(named: 'code'),
            isAuthorized: any(named: 'isAuthorized'),
          ),
        ).thenAnswer((_) async => const Result.failure(Failure.general()));
      },
      build: () => LoanCalculatorBloc(
        localization: localization,
        repository: repository,
        documentsCode: documentsCode,
        productId: productId,
      ),
      act: (bloc) => bloc.add(const LoanCalculatorEvent.loadConditions()),
      expect: () => <LoanCalculatorState>[const LoanCalculatorState(termsFailure: Failure.general())],
      expectActions: () => <LoanCalculatorAction>[],
    );

    baseBlocTest<LoanCalculatorBloc, LoanCalculatorEvent, LoanCalculatorState, LoanCalculatorAction, BaseLocalization>(
      'При переключении расширения ежемесячного платежа должно изменяться состояние',
      build: () => LoanCalculatorBloc(
        localization: localization,
        repository: repository,
        documentsCode: documentsCode,
        productId: productId,
      ),
      act: (bloc) => bloc.add(const LoanCalculatorEvent.toggleMonthlyPaymentExpansion()),
      expect: () => <LoanCalculatorState>[const LoanCalculatorState(isMonthlyAmountExpanded: true)],
      expectActions: () => <LoanCalculatorAction>[],
    );

    baseBlocTest<LoanCalculatorBloc, LoanCalculatorEvent, LoanCalculatorState, LoanCalculatorAction, BaseLocalization>(
      'При нажатии на документ должно эмиттиться действие запроса документа',
      build: () => LoanCalculatorBloc(
        localization: localization,
        repository: repository,
        documentsCode: documentsCode,
        productId: productId,
      ),
      act: (bloc) => bloc.add(LoanCalculatorEvent.onDocumentTap(document: document)),
      expect: () => <LoanCalculatorState>[],
      expectActions: () => <LoanCalculatorAction>[LoanCalculatorAction.documentRequested(document: document)],
    );

    baseBlocTest<LoanCalculatorBloc, LoanCalculatorEvent, LoanCalculatorState, LoanCalculatorAction, BaseLocalization>(
      'При нажатии на приватный документ не должно эмиттиться действие',
      setUp: () {
        when(() => document.private).thenReturn(true);
      },
      build: () => LoanCalculatorBloc(
        localization: localization,
        repository: repository,
        documentsCode: documentsCode,
        productId: productId,
      ),
      act: (bloc) => bloc.add(LoanCalculatorEvent.onDocumentTap(document: document)),
      expect: () => <LoanCalculatorState>[],
      expectActions: () => <LoanCalculatorAction>[],
    );

    baseBlocTest<LoanCalculatorBloc, LoanCalculatorEvent, LoanCalculatorState, LoanCalculatorAction, BaseLocalization>(
      'При изменении состояния загрузки должно обновляться состояние',
      build: () => LoanCalculatorBloc(
        localization: localization,
        repository: repository,
        documentsCode: documentsCode,
        productId: productId,
      ),
      act: (bloc) => bloc.add(const LoanCalculatorEvent.loadingChanged(isLoading: true)),
      expect: () => <LoanCalculatorState>[const LoanCalculatorState(isLoading: true)],
      expectActions: () => <LoanCalculatorAction>[],
    );

    baseBlocTest<LoanCalculatorBloc, LoanCalculatorEvent, LoanCalculatorState, LoanCalculatorAction, BaseLocalization>(
      'При ошибке получения ежемесячного платежа должно устанавливаться состояние с ошибкой',
      setUp: () {
        when(
          () => repository.getMonthlyPayment(
            currentAmount: any(named: 'currentAmount'),
            currentTerm: any(named: 'currentTerm'),
            productId: any(named: 'productId'),
            applicationId: any(named: 'applicationId'),
          ),
        ).thenAnswer((_) async => const Result.failure(Failure.general()));
      },
      seed: () => LoanCalculatorState(minLimit: minAmount, maxLimit: maxAmount, currentDuration: testDuration),
      build: () => LoanCalculatorBloc(
        localization: localization,
        repository: repository,
        documentsCode: documentsCode,
        productId: productId,
      ),
      act: (bloc) => bloc.add(LoanCalculatorEvent.currencyAmountChanged(amount: currentAmount)),
      wait: const Duration(milliseconds: 600),
      expect: () => <LoanCalculatorState>[
        LoanCalculatorState(
          minLimit: minAmount,
          maxLimit: maxAmount,
          currentDuration: testDuration,
          termsFailure: null,
          monthlyFailure: null,
          monthlyAmount: null,
          totalAmount: null,
          isMonthlyAmountLoading: true,
        ),
        LoanCalculatorState(
          minLimit: minAmount,
          maxLimit: maxAmount,
          currentDuration: testDuration,
          monthlyFailure: const Failure.general(),
          isMonthlyAmountLoading: false,
          currentAmount: currentAmount,
        ),
      ],
      expectActions: () => <LoanCalculatorAction>[],
    );
  });
}
