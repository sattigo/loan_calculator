part of 'loan_calculator_widget.dart';

class _LoanCalculatorMonthlyIncomeWidget extends BaseStatelessWidget {
  const _LoanCalculatorMonthlyIncomeWidget({
    required LoanCalculatorLocalizationContract localization,
    required LoanCalculatorState state,
    required VoidCallback onRefresh,
  }) : _localization = localization,
       _state = state,
       _onRefresh = onRefresh;
  final LoanCalculatorLocalizationContract _localization;
  final LoanCalculatorState _state;
  final VoidCallback _onRefresh;

  @override
  Widget build(BuildContext context) {
    if (_state.monthlyIncomeFailure != null) {
      return _buildFailureState(context);
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text.button(text: _localization.yourMonthlyIncome(context)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CurrencyTextFieldWidget(bloc: context.bloc<MonthlyIncomeCurrencyTextFieldBloc>()),
          ),
        ],
      );
    }
  }

  Widget _buildFailureState(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 43.5),
      decoration: BoxDecoration(
        color: context.theme().colors.onSurfaceVariant3.shade50,
        borderRadius: context.theme().corners.medium,
        boxShadow: context.theme().shadows.light,
      ),
      child: WidgetButton(
        iosButtonOnPressedAnimation: ButtonBackgroundColorChangeAnimationStyle(
          backgroundColorPressed: context.theme().colors.onSurfaceVariant3.shade100,
        ),
        androidButtonOnPressedAnimation: ButtonBackgroundColorChangeAnimationStyle(
          backgroundColorPressed: context.theme().colors.onSurfaceVariant3.shade100,
        ),
        borderRadius: context.theme().corners.medium,
        backgroundColor: context.theme().colors.surfaceVariant3,
        onPressed: _onRefresh,
        child: Container(
          padding: const EdgeInsets.all(16),
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.images.reload.svg(
                height: 20,
                width: 20,
                colorFilter: ColorFilter.mode(context.theme().colors.onSurfaceVariant3.shade900, BlendMode.srcIn),
              ),
              const SizedBox(height: 8),
              Text.caption1Regular(
                text: _localization.monthlyIncomeLoadingFailure(context),
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
