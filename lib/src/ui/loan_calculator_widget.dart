import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_framework/date_time/formatter/date_time_formatter.dart';
import 'package:flutter_framework/error/domain/object/failure.build.dart';
import 'package:flutter_framework/platform/platform_type_service.dart';
import 'package:jiffy/jiffy.dart';
import 'package:base/base_widget.dart';
import 'package:common_features/common_features.dart';
import 'package:currency/currency.dart';
import 'package:documents/documents.dart';
import 'package:loan_calculator/loan_calculator.dart';
import 'package:loan_core_objects/loan_core_objects.dart';
import 'package:ui_kit/ui_kit.dart';

part 'loan_calculator_monthly_payment_layout_widget.dart';

part 'monthly_income_widget.dart';

part 'months_slider.dart';

class LoanCalculatorWidget extends StatefulWidget {
  const LoanCalculatorWidget({required bool isReviewServer, required VoidCallback onFailurePressed, super.key})
    : _isReviewServer = isReviewServer,
      _onFailurePressed = onFailurePressed;

  final bool _isReviewServer;
  final VoidCallback _onFailurePressed;

  @override
  State<LoanCalculatorWidget> createState() => _LoanCalculatorWidgetState();
}

class _LoanCalculatorWidgetState extends BaseState<LoanCalculatorWidget> {
  late final LoanCalculatorBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = bloc();
  }

  void _onMonthlyPaymentErrorPressed() {
    _bloc.add(LoanCalculatorEvent.currencyAmountChanged(amount: _bloc.state.currentAmount));
    _bloc.add(const LoanCalculatorEvent.loadConditions());
  }

  void _onMonthlyPaymentPressed() {
    _bloc.add(const LoanCalculatorEvent.toggleMonthlyPaymentExpansion());
  }

  void _onDocumentTap(Document document) {
    _bloc.add(LoanCalculatorEvent.onDocumentTap(document: document));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoanCalculatorBloc, LoanCalculatorState>(
      builder: (context, state) {
        final duration = state.currentDuration?.size;
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text.button(
                  text: widget._isReviewServer
                      ? _bloc.localization.amountAtRate(context)
                      : _bloc.localization.loanAmount(context),
                ),
              ),
              _buildCurrencyTextField(context, state: state),
              SizedBox(
                height: state.limitsFailure != null || state.termsFailure != null || state.minLimit == null ? 8 : 28,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text.button(
                  text: widget._isReviewServer
                      ? duration != null
                            ? _bloc.localization.mustBePaidBy(
                                context: context,
                                dateTime: Jiffy.now().add(months: duration).dateTime.formatAsDDMMy(),
                              )
                            : ''
                      : _bloc.localization.term(context),
                ),
              ),
              ..._buildBottomWidgets(state),
              _buildConditionsText(state),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SecondaryButton(
                  text: _bloc.localization.proceed(context),
                  expandedWidth: true,
                  loading: state.isLoading,
                  onPressed: state.canProceed
                      ? () {
                          _bloc.add(const LoanCalculatorEvent.proceed());
                        }
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildBottomWidgets(LoanCalculatorState state) {
    final tempDuration = state.tempDuration;
    if (state.termsFailure != null || state.limitsFailure != null) {
      return [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Error(
            androidButtonOnPressedAnimation: ButtonBackgroundColorChangeAnimationStyle(
              backgroundColorPressed: theme().colors.onSurfaceVariant3.shade50,
            ),
            iosButtonOnPressedAnimation: ButtonBackgroundColorChangeAnimationStyle(
              backgroundColorPressed: theme().colors.onSurfaceVariant3.shade50,
            ),
            onPressed: () {
              state.termsFailure != null
                  ? _bloc.add(LoanCalculatorEvent.currencyAmountChanged(amount: state.currentAmount))
                  : _bloc.add(const LoanCalculatorEvent.loadLoanInfo());
            },
            customDecoration: BoxDecoration(borderRadius: theme().corners.medium),
            titlePadding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            refreshPadding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
            failure: Failure.userFriendly(
              title: _bloc.localization.sumError(context),
              errors: [_bloc.localization.tapToUpdate(context)],
            ),
            localization: _bloc.localization.errorWidgetLocalization,
          ),
        ),
        const SizedBox(height: 20),
      ];
    } else {
      final isExpanded =
          state.minLimit != null &&
          state.currentAmount?.amount != Decimal.zero &&
          state.minLimit!.amount <= state.currentAmount!.amount &&
          state.maxLimit!.amount >= state.currentAmount!.amount;
      return [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 8),
          child: _MonthsSlider(
            monthsLabel: tempDuration != null ? _bloc.localization.month(context, tempDuration.size) : null,
            labelPadding: const EdgeInsets.symmetric(horizontal: 16),
            tempDuration: state.tempDuration,
            durations: state.durations,
            onChanged: (value) {
              _bloc.add(LoanCalculatorEvent.durationChangeStarted(duration: state.durations[value.toInt()]));
            },
            onChangeEnd: (_) {
              _bloc.add(const LoanCalculatorEvent.durationChangeEnded());
            },
          ),
        ),
        SizedBox(height: isExpanded ? 0 : 20),
        if (isExpanded) _buildMonthlyPayment(state),
        if (state.minIncome != null && state.maxIncome != null) ...[
          const SizedBox(height: 8),
          _LoanCalculatorMonthlyIncomeWidget(
            localization: _bloc.localization,
            state: state,
            onRefresh: widget._onFailurePressed,
          ),
          const SizedBox(height: 36),
        ],
      ];
    }
  }

  Widget _buildCurrencyTextField(BuildContext context, {required LoanCalculatorState state}) {
    if (state.maxLimit != null || state.limitsFailure != null) {
      return const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: CurrencyTextFieldWidget());
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: PlatformTypeService.execute(android: () => 21, iOS: () => 22),
            ),
            ShimmerContainer(width: 123, height: 16, borderRadius: theme().corners.large),
            SizedBox(
              height: PlatformTypeService.execute(android: () => 21, iOS: () => 22),
            ),
            Container(height: 1, width: double.maxFinite, color: theme().colors.onSurfaceVariant3.shade100),
          ],
        ),
      );
    }
  }

  Widget _buildMonthlyPayment(LoanCalculatorState state) {
    final localization = _bloc.localization;
    if (state.monthlyFailure != null) {
      return _LoanCalculatorMonthlyPaymentLayoutWidget.error(
        localization: localization,
        onPressed: _onMonthlyPaymentErrorPressed,
      );
    } else if (state.isMonthlyAmountLoading || state.monthlyAmount == null) {
      return _LoanCalculatorMonthlyPaymentLayoutWidget.shimmer(localization: localization, onPressed: () {});
    } else {
      return _LoanCalculatorMonthlyPaymentLayoutWidget.content(
        monthlyAmount: state.monthlyAmount!,
        totalAmount: state.totalAmount,
        isExpanded: state.isMonthlyAmountExpanded,
        onPressed: state.canExpandMonthlyPayment ? _onMonthlyPaymentPressed : null,
        localization: localization,
        isReviewServer: widget._isReviewServer,
      );
    }
  }

  Widget _buildConditionsText(LoanCalculatorState state) {
    final documents = state.documents;
    if (documents != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: RichText(
          textAlign: TextAlign.center,
          text: documents.getTextSpans(
            onDocumentTap: _onDocumentTap,
            defaultTextStyle: theme().fonts.caption1Regular.copyWith(color: theme().colors.onSurfaceVariant3.shade600),
            linkedTextStyle: theme().fonts.caption1Regular.copyWith(
              color: theme().colors.secondary,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
