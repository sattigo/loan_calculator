import 'package:decimal/decimal.dart';
import 'package:test/test.dart';
import 'package:currency/currency.dart';
import 'package:loan_calculator/src/domain/bloc/bloc.build.dart';

void main() {
  group('LoanCalculatorStateX', () {
    final minAmount = CurrencyAmount(amount: Decimal.fromInt(1000000), currency: CurrencyProvider.uzs);
    final maxAmount = CurrencyAmount(amount: Decimal.fromInt(50000000), currency: CurrencyProvider.uzs);
    final currentAmount = CurrencyAmount(amount: Decimal.fromInt(5000000), currency: CurrencyProvider.uzs);
    final monthlyAmount = CurrencyAmount(amount: Decimal.fromInt(500000), currency: CurrencyProvider.uzs);
    final minIncome = CurrencyAmount(amount: Decimal.fromInt(2000000), currency: CurrencyProvider.uzs);
    final maxIncome = CurrencyAmount(amount: Decimal.fromInt(100000000), currency: CurrencyProvider.uzs);
    final currentIncome = CurrencyAmount(amount: Decimal.fromInt(5000000), currency: CurrencyProvider.uzs);
    final zeroAmount = CurrencyAmount(amount: Decimal.zero, currency: CurrencyProvider.uzs);

    group('canProceed', () {
      test('должно возвращать true когда все условия выполнены', () {
        final state = LoanCalculatorState(
          monthlyAmount: monthlyAmount,
          minLimit: minAmount,
          maxLimit: maxAmount,
          currentAmount: currentAmount,
          minIncome: minIncome,
          maxIncome: maxIncome,
          currentIncome: currentIncome,
        );

        expect(state.canProceed, isTrue);
      });

      test('должно возвращать false когда monthlyAmount равен null', () {
        final state = LoanCalculatorState(
          monthlyAmount: null,
          minLimit: minAmount,
          maxLimit: maxAmount,
          currentAmount: currentAmount,
          minIncome: minIncome,
          maxIncome: maxIncome,
          currentIncome: currentIncome,
        );

        expect(state.canProceed, isFalse);
      });

      test('должно возвращать false когда monthlyAmount равен нулю', () {
        final state = LoanCalculatorState(
          monthlyAmount: zeroAmount,
          minLimit: minAmount,
          maxLimit: maxAmount,
          currentAmount: currentAmount,
          minIncome: minIncome,
          maxIncome: maxIncome,
          currentIncome: currentIncome,
        );

        expect(state.canProceed, isFalse);
      });

      test('должно возвращать false когда minLimit равен null', () {
        final state = LoanCalculatorState(
          monthlyAmount: monthlyAmount,
          minLimit: null,
          maxLimit: maxAmount,
          currentAmount: currentAmount,
          minIncome: minIncome,
          maxIncome: maxIncome,
          currentIncome: currentIncome,
        );

        expect(state.canProceed, isFalse);
      });

      test('должно возвращать false когда currentAmount меньше minLimit', () {
        final state = LoanCalculatorState(
          monthlyAmount: monthlyAmount,
          minLimit: minAmount,
          maxLimit: maxAmount,
          currentAmount: CurrencyAmount(amount: Decimal.fromInt(500000), currency: CurrencyProvider.uzs),
          minIncome: minIncome,
          maxIncome: maxIncome,
          currentIncome: currentIncome,
        );

        expect(state.canProceed, isFalse);
      });

      test('должно возвращать false когда currentAmount больше maxLimit', () {
        final state = LoanCalculatorState(
          monthlyAmount: monthlyAmount,
          minLimit: minAmount,
          maxLimit: maxAmount,
          currentAmount: CurrencyAmount(amount: Decimal.fromInt(100000000), currency: CurrencyProvider.uzs),
          minIncome: minIncome,
          maxIncome: maxIncome,
          currentIncome: currentIncome,
        );

        expect(state.canProceed, isFalse);
      });

      test('должно возвращать false когда currentAmount равен null', () {
        final state = LoanCalculatorState(
          monthlyAmount: monthlyAmount,
          minLimit: minAmount,
          maxLimit: maxAmount,
          currentAmount: null,
          minIncome: minIncome,
          maxIncome: maxIncome,
          currentIncome: currentIncome,
        );

        expect(state.canProceed, isFalse);
      });

      test('должно возвращать false когда currentAmount равен нулю', () {
        final state = LoanCalculatorState(
          monthlyAmount: monthlyAmount,
          minLimit: minAmount,
          maxLimit: maxAmount,
          currentAmount: zeroAmount,
          minIncome: minIncome,
          maxIncome: maxIncome,
          currentIncome: currentIncome,
        );

        expect(state.canProceed, isFalse);
      });

      test('должно возвращать true когда фича дохода выключена', () {
        final state = LoanCalculatorState(
          monthlyAmount: monthlyAmount,
          minLimit: minAmount,
          maxLimit: maxAmount,
          currentAmount: currentAmount,
          minIncome: null,
          maxIncome: null,
          currentIncome: null,
        );

        expect(state.canProceed, isTrue);
      });

      test('должно возвращать false когда фича дохода включена но доход невалидный', () {
        final state = LoanCalculatorState(
          monthlyAmount: monthlyAmount,
          minLimit: minAmount,
          maxLimit: maxAmount,
          currentAmount: currentAmount,
          minIncome: minIncome,
          maxIncome: maxIncome,
          currentIncome: CurrencyAmount(amount: Decimal.fromInt(1000000), currency: CurrencyProvider.uzs),
        );

        expect(state.canProceed, isFalse);
      });
    });

    group('canExpandMonthlyPayment', () {
      test('должно возвращать true когда все условия выполнены', () {
        final state = LoanCalculatorState(
          monthlyAmount: monthlyAmount,
          minLimit: minAmount,
          maxLimit: maxAmount,
          currentAmount: currentAmount,
        );

        expect(state.canExpandMonthlyPayment, isTrue);
      });

      test('должно возвращать false когда monthlyAmount равен null', () {
        final state = LoanCalculatorState(
          monthlyAmount: null,
          minLimit: minAmount,
          maxLimit: maxAmount,
          currentAmount: currentAmount,
        );

        expect(state.canExpandMonthlyPayment, isFalse);
      });

      test('должно возвращать false когда monthlyAmount равен нулю', () {
        final state = LoanCalculatorState(
          monthlyAmount: zeroAmount,
          minLimit: minAmount,
          maxLimit: maxAmount,
          currentAmount: currentAmount,
        );

        expect(state.canExpandMonthlyPayment, isFalse);
      });

      test('должно возвращать false когда currentAmount меньше minLimit', () {
        final state = LoanCalculatorState(
          monthlyAmount: monthlyAmount,
          minLimit: minAmount,
          maxLimit: maxAmount,
          currentAmount: CurrencyAmount(amount: Decimal.fromInt(500000), currency: CurrencyProvider.uzs),
        );

        expect(state.canExpandMonthlyPayment, isFalse);
      });

      test('должно возвращать false когда currentAmount больше maxLimit', () {
        final state = LoanCalculatorState(
          monthlyAmount: monthlyAmount,
          minLimit: minAmount,
          maxLimit: maxAmount,
          currentAmount: CurrencyAmount(amount: Decimal.fromInt(100000000), currency: CurrencyProvider.uzs),
        );

        expect(state.canExpandMonthlyPayment, isFalse);
      });
    });

    group('isIncomeFeatureEnabled', () {
      test('должно возвращать true когда minIncome и maxIncome заданы', () {
        final state = LoanCalculatorState(minIncome: minIncome, maxIncome: maxIncome);

        expect(state.isIncomeFeatureEnabled, isTrue);
      });

      test('должно возвращать false когда minIncome равен null', () {
        final state = LoanCalculatorState(minIncome: null, maxIncome: maxIncome);

        expect(state.isIncomeFeatureEnabled, isFalse);
      });

      test('должно возвращать false когда maxIncome равен null', () {
        final state = LoanCalculatorState(minIncome: minIncome, maxIncome: null);

        expect(state.isIncomeFeatureEnabled, isFalse);
      });

      test('должно возвращать false когда и minIncome и maxIncome равны null', () {
        const state = LoanCalculatorState(minIncome: null, maxIncome: null);

        expect(state.isIncomeFeatureEnabled, isFalse);
      });
    });

    group('isIncomeFeatureValid', () {
      test('должно возвращать true когда все условия выполнены', () {
        final state = LoanCalculatorState(minIncome: minIncome, maxIncome: maxIncome, currentIncome: currentIncome);

        expect(state.isIncomeFeatureValid, isTrue);
      });

      test('должно возвращать false когда minIncome равен null', () {
        final state = LoanCalculatorState(minIncome: null, maxIncome: maxIncome, currentIncome: currentIncome);

        expect(state.isIncomeFeatureValid, isFalse);
      });

      test('должно возвращать false когда currentIncome меньше minIncome', () {
        final state = LoanCalculatorState(
          minIncome: minIncome,
          maxIncome: maxIncome,
          currentIncome: CurrencyAmount(amount: Decimal.fromInt(1000000), currency: CurrencyProvider.uzs),
        );

        expect(state.isIncomeFeatureValid, isFalse);
      });

      test('должно возвращать false когда currentIncome больше maxIncome', () {
        final state = LoanCalculatorState(
          minIncome: minIncome,
          maxIncome: maxIncome,
          currentIncome: CurrencyAmount(amount: Decimal.fromInt(200000000), currency: CurrencyProvider.uzs),
        );

        expect(state.isIncomeFeatureValid, isFalse);
      });

      test('должно возвращать false когда currentIncome равен null', () {
        final state = LoanCalculatorState(minIncome: minIncome, maxIncome: maxIncome, currentIncome: null);

        expect(state.isIncomeFeatureValid, isFalse);
      });

      test('должно возвращать false когда currentIncome равен нулю', () {
        final state = LoanCalculatorState(minIncome: minIncome, maxIncome: maxIncome, currentIncome: zeroAmount);

        expect(state.isIncomeFeatureValid, isFalse);
      });

      test('должно возвращать false когда maxIncome равен null', () {
        final state = LoanCalculatorState(minIncome: minIncome, maxIncome: null, currentIncome: currentIncome);

        expect(state.isIncomeFeatureValid, isFalse);
      });
    });
  });
}
