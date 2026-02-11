import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_framework/base_bloc/base_bloc.dart';
import 'package:flutter_framework/error/domain/object/failure.build.dart';
import 'package:flutter_framework/result/result.build.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:currency/currency.dart';
import 'package:documents/documents.dart';
import 'package:loan_calculator/loan_calculator.dart';
import 'package:loan_core_objects/loan_core_objects.dart';

part 'action.dart';

part 'bloc.build.freezed.dart';

part 'event.dart';

part 'state.dart';

class LoanCalculatorBloc
    extends
        BaseBloc<LoanCalculatorEvent, LoanCalculatorState, LoanCalculatorAction, LoanCalculatorLocalizationContract> {
  LoanCalculatorBloc({
    required LoanCalculatorLocalizationContract localization,
    required LoanCalculatorRepositoryContract repository,
    required String documentsCode,
    String? productId,
  }) : _repository = repository,
       _productId = productId,
       _documentsCode = documentsCode,
       super(const LoanCalculatorState(), localization: localization) {
    on<_LoanCalculatorEventLoadLoanInfo>(_onEventLoadLoanInfo);
    on<_LoanCalculatorEventProceed>((event, _) => _onEventLoanCalculatorProceed(event));
    on<_LoanCalculatorEventLoadConditions>((event, emit) => _onEventLoanCalculatorLoadConditions(emit));
    on<_LoanCalculatorEventCurrencyAmountChanged>(
      _onEventLoanCalculatorCurrencyAmountChanged,
      transformer: _debounceTransformer,
    );
    on<_LoanCalculatorEventIncomeAmountChanged>(
      _onEventLoanCalculatorIncomeAmountChanged,
      transformer: _debounceTransformer,
    );
    on<_LoanCalculatorEventDurationChangeStarted>(_onEventLoanCalculatorDurationChangeStarted);
    on<_LoanCalculatorEventDurationChangeEnded>(_onEventLoanCalculatorDurationChangeEnded);
    on<_LoanCalculatorEventLoadingChanged>(_onEventLoanCalculatorLoadingChanged);
    on<_LoanCalculatorEventCurrencyAmountEditingCompleted>((_, _) => _onEventCurrencyAmountEditingCompleted());
    on<_LoanCalculatorEventToggleMonthlyPaymentExpansion>((_, emit) => _onEventToggleMonthlyPaymentExpansion(emit));
    on<_LoanCalculatorEventOnDocumentTap>(_onEventDocumentPressed);
  }

  final LoanCalculatorRepositoryContract _repository;
  final String? _productId;
  final String _documentsCode;

  void _onEventLoanCalculatorDurationChangeStarted(
    _LoanCalculatorEventDurationChangeStarted event,
    Emitter<LoanCalculatorState> emit,
  ) {
    emit(state.copyWith(tempDuration: event.duration));
  }

  Stream<T> _debounceTransformer<T>(Stream<T> events, Stream<T> Function(T) mapper) {
    return events.debounceTime(const Duration(milliseconds: 500)).flatMap(mapper);
  }

  Future<void> _onEventCurrencyAmountEditingCompleted() async {
    if (state.currentAmount?.amount != Decimal.zero &&
        state.minLimit != null &&
        state.maxLimit != null &&
        state.currentAmount?.amount != null &&
        state.minLimit!.amount <= state.currentAmount!.amount &&
        state.maxLimit!.amount >= state.currentAmount!.amount) {
      await _repository.amountEditingCompleted();
    }
  }

  Future<void> _onEventLoadLoanInfo(_LoanCalculatorEventLoadLoanInfo event, Emitter<LoanCalculatorState> emit) async {
    emit(state.copyWith(limitsFailure: null, applicationId: event.loanCalculatorData?.applicationId));
    final limitsResult = await _repository.getLoanApplicationForm(
      productId: _productId,
      applicationId: event.loanCalculatorData?.applicationId,
    );
    switch (limitsResult) {
      case Success<LoanApplicationForm, Failure>(:final data):
        final durations = data.validations.durations.sorted(
          (duration1, duration2) => duration1.size < duration2.size ? -1 : 1,
        );
        final currentDuration = event.loanCalculatorData != null ? event.loanCalculatorData!.duration : durations.last;
        final minAmount = data.validations.amount.minAmount;
        final maxAmount = data.validations.amount.maxAmount;
        final currentAmount = event.loanCalculatorData != null ? event.loanCalculatorData!.amount : maxAmount;
        final minIncome = data.validations.monthlyIncome?.minAmount;
        final maxIncome = data.validations.monthlyIncome?.maxAmount;
        final currentIncome = event.loanCalculatorData != null
            ? event.loanCalculatorData!.income
            : data.fields.defaultMonthlyIncome ?? minIncome;
        emit(
          state.copyWith(
            minLimit: minAmount,
            maxLimit: maxAmount,
            currentAmount: currentAmount,
            durations: durations,
            tempDuration: currentDuration,
            currentDuration: currentDuration,
            minIncome: minIncome,
            maxIncome: maxIncome,
            currentIncome: currentIncome,
          ),
        );
        emitAction(
          LoanCalculatorAction.limitsLoaded(
            minAmount: minAmount,
            maxAmount: maxAmount,
            minIncome: minIncome,
            maxIncome: maxIncome,
          ),
        );
        add(LoanCalculatorEvent.currencyAmountChanged(amount: currentAmount));
        add(LoanCalculatorEvent.incomeAmountChanged(amount: currentIncome));
        emitAction(LoanCalculatorAction.currencyAmountChanged(currentAmount));
        if (currentIncome != null) {
          emitAction(LoanCalculatorAction.incomeAmountChanged(currentIncome));
        }
      case Error<LoanApplicationForm, Failure>(:final error):
        emit(state.copyWith(limitsFailure: error));
    }
  }

  Future<void> _onEventLoanCalculatorProceed(_LoanCalculatorEventProceed event) async {
    // Only proceed if we have valid data
    if (state.currentAmount != null && state.currentDuration != null) {
      await _repository.proceed();
      emitAction(
        LoanCalculatorAction.proceed(
          loanCalculatorData: LoanCalculatorData(
            amount: state.currentAmount!,
            duration: state.currentDuration!,
            productId: _productId,
            income: state.currentIncome,
          ),
        ),
      );
    }
  }

  Future<void> _onEventLoanCalculatorLoadConditions(Emitter<LoanCalculatorState> emit) async {
    final conditionsUriResult = await _repository.getDocuments(code: _documentsCode, isAuthorized: true);

    switch (conditionsUriResult) {
      case Success<Documents, Failure>(:final data):
        emit(state.copyWith(documents: data));
      case Error<Documents, Failure>(:final error):
        emit(state.copyWith(termsFailure: error));
    }
  }

  Future<void> _onEventLoanCalculatorIncomeAmountChanged(
    _LoanCalculatorEventIncomeAmountChanged event,
    Emitter<LoanCalculatorState> emit,
  ) async {
    emit(state.copyWith(currentIncome: event.amount));
  }

  Future<void> _onEventLoanCalculatorCurrencyAmountChanged(
    _LoanCalculatorEventCurrencyAmountChanged event,
    Emitter<LoanCalculatorState> emit,
  ) async {
    if (event.amount?.amount != Decimal.zero &&
        state.minLimit != null &&
        state.maxLimit != null &&
        event.amount?.amount != null &&
        state.minLimit!.amount <= event.amount!.amount &&
        state.maxLimit!.amount >= event.amount!.amount) {
      emit(
        state.copyWith(
          termsFailure: null,
          monthlyFailure: null,
          monthlyAmount: null,
          totalAmount: null,
          isMonthlyAmountLoading: true,
        ),
      );

      final monthlyPaymentResult = await _repository.getMonthlyPayment(
        currentAmount: event.amount!,
        currentTerm: state.currentDuration!.size,
        productId: _productId,
        applicationId: state.applicationId,
      );

      switch (monthlyPaymentResult) {
        case Success<MonthlyPayment, Failure>(:final data):
          emit(
            state.copyWith(
              monthlyAmount: data.monthlyAmount,
              currentAmount: event.amount,
              totalAmount: data.totalAmount,
              isMonthlyAmountLoading: false,
            ),
          );
        case Error<MonthlyPayment, Failure>(:final error):
          emit(state.copyWith(monthlyFailure: error, isMonthlyAmountLoading: false, currentAmount: event.amount));
      }
    } else {
      if (state.minLimit != null && event.amount != null) {
        if (event.amount!.amount < state.minLimit!.amount) {
          await _repository.sendAmountBelowMin();
        }
        if (state.maxLimit != null && event.amount!.amount > state.maxLimit!.amount) {
          await _repository.sendAmountAboveMax();
        }
      }
      emit(state.copyWith(currentAmount: event.amount, monthlyAmount: null));
    }
  }

  Future<void> _onEventLoanCalculatorDurationChangeEnded(
    _LoanCalculatorEventDurationChangeEnded event,
    Emitter<LoanCalculatorState> emit,
  ) async {
    if ((state.tempDuration?.unit == state.currentDuration?.unit) &&
        (state.tempDuration?.size != state.currentDuration?.size)) {
      if (state.currentAmount?.amount != Decimal.zero &&
          state.minLimit != null &&
          state.maxLimit != null &&
          state.currentAmount?.amount != null &&
          state.minLimit!.amount <= state.currentAmount!.amount &&
          state.maxLimit!.amount >= state.currentAmount!.amount) {
        emit(state.copyWith(monthlyFailure: null, currentDuration: state.tempDuration, isMonthlyAmountLoading: true));
        await _repository.durationChanged();

        final monthlyPaymentResult = await _repository.getMonthlyPayment(
          currentAmount: state.currentAmount!,
          currentTerm: state.tempDuration?.size ?? 0,
          productId: _productId,
          applicationId: state.applicationId,
        );
        switch (monthlyPaymentResult) {
          case Success<MonthlyPayment, Failure>(:final data):
            emit(
              state.copyWith(
                monthlyAmount: data.monthlyAmount,
                totalAmount: data.totalAmount,
                isMonthlyAmountLoading: false,
              ),
            );
          case Error<MonthlyPayment, Failure>(:final error):
            emit(state.copyWith(monthlyFailure: error, isMonthlyAmountLoading: false));
        }
      } else {
        emit(
          state.copyWith(
            monthlyFailure: null,
            monthlyAmount: state.currentAmount,
            totalAmount: state.totalAmount,
            currentDuration: state.tempDuration,
          ),
        );
      }
    }
  }

  void _onEventLoanCalculatorLoadingChanged(
    _LoanCalculatorEventLoadingChanged event,
    Emitter<LoanCalculatorState> emit,
  ) {
    emit(state.copyWith(isLoading: event.isLoading));
  }

  Future<void> _onEventToggleMonthlyPaymentExpansion(Emitter<LoanCalculatorState> emit) async {
    emit(state.copyWith(isMonthlyAmountExpanded: !state.isMonthlyAmountExpanded));
    await _repository.monthlyPaymentPressed();
  }

  Future<void> _onEventDocumentPressed(
    _LoanCalculatorEventOnDocumentTap event,
    Emitter<LoanCalculatorState> emit,
  ) async {
    if (!event.document.private) {
      emitAction(LoanCalculatorAction.documentRequested(document: event.document));
    }
  }
}
