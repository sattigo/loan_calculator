part of 'loan_calculator_widget.dart';

abstract class _LoanCalculatorMonthlyPaymentLayoutWidget extends BaseStatelessWidget {
  const _LoanCalculatorMonthlyPaymentLayoutWidget._({
    required VoidCallback? onPressed,
    required LoanCalculatorLocalizationContract localization,
    super.key,
  }) : _onPressed = onPressed,
       _localization = localization;

  factory _LoanCalculatorMonthlyPaymentLayoutWidget.shimmer({
    required VoidCallback? onPressed,
    required LoanCalculatorLocalizationContract localization,
    Key? key,
  }) => _LoanCalculatorMonthlyPaymentLayoutWidgetShimmer._(key: key, onPressed: onPressed, localization: localization);

  factory _LoanCalculatorMonthlyPaymentLayoutWidget.error({
    required VoidCallback? onPressed,
    required LoanCalculatorLocalizationContract localization,
    Key? key,
  }) => _LoanCalculatorMonthlyPaymentLayoutWidgetError._(key: key, onPressed: onPressed, localization: localization);

  factory _LoanCalculatorMonthlyPaymentLayoutWidget.content({
    required CurrencyAmount monthlyAmount,
    required CurrencyAmount? totalAmount,
    required bool isExpanded,
    required VoidCallback? onPressed,
    required LoanCalculatorLocalizationContract localization,
    required bool isReviewServer,
    Key? key,
  }) => _LoanCalculatorMonthlyPaymentLayoutWidgetContent._(
    key: key,
    monthlyAmount: monthlyAmount,
    totalAmount: totalAmount,
    isExpanded: isExpanded,
    onPressed: onPressed,
    localization: localization,
    isReviewServer: isReviewServer,
  );
  final VoidCallback? _onPressed;
  final LoanCalculatorLocalizationContract _localization;

  Widget _buildContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return ExpansionPanel(
      expanded: true,
      expandedWidgets: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            boxShadow: context.theme().shadows.light,
            borderRadius: context.theme().corners.medium,
          ),
          child: WidgetButton(
            onPressed: _onPressed,
            androidButtonOnPressedAnimation: ButtonNativeAndroidAnimationStyle(
              splashColor: context.theme().colors.onSurfaceVariant3.shade50,
            ),
            iosButtonOnPressedAnimation: const ButtonScaleAnimationStyle(),
            borderRadius: context.theme().corners.medium,
            backgroundColor: context.theme().colors.surfaceVariant3,
            child: Padding(padding: const EdgeInsets.all(16), child: _buildContent(context)),
          ),
        ),
      ],
    );
  }
}

class _LoanCalculatorMonthlyPaymentLayoutWidgetShimmer extends _LoanCalculatorMonthlyPaymentLayoutWidget {
  const _LoanCalculatorMonthlyPaymentLayoutWidgetShimmer._({
    required super.onPressed,
    required super.localization,
    super.key,
  }) : super._();

  @override
  Widget _buildContent(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: PlatformTypeService.execute(android: () => 1, iOS: () => 2),
              ),
              ShimmerContainer(width: 116, height: 15, borderRadius: context.theme().corners.medium),
              const SizedBox(height: 12),
              ShimmerContainer(width: 209, height: 15, borderRadius: context.theme().corners.medium),
              SizedBox(
                height: PlatformTypeService.execute(android: () => 1, iOS: () => 2),
              ),
            ],
          ),
        ),
        Assets.images.infoVersion5.svg(),
      ],
    );
  }
}

class _LoanCalculatorMonthlyPaymentLayoutWidgetError extends _LoanCalculatorMonthlyPaymentLayoutWidget {
  const _LoanCalculatorMonthlyPaymentLayoutWidgetError._({
    required super.onPressed,
    required super.localization,
    super.key,
  }) : super._();

  @override
  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        SizedBox.square(
          dimension: 20,
          child: Assets.images.reload.svg(
            colorFilter: ColorFilter.mode(context.theme().colors.onSurfaceVariant3.shade900, BlendMode.srcIn),
          ),
        ),
        const SizedBox(height: 8, width: double.maxFinite),
        Text.caption1Regular(text: _localization.unableToLoadInformation(context)),
      ],
    );
  }
}

class _LoanCalculatorMonthlyPaymentLayoutWidgetContent extends _LoanCalculatorMonthlyPaymentLayoutWidget {
  const _LoanCalculatorMonthlyPaymentLayoutWidgetContent._({
    required CurrencyAmount monthlyAmount,
    required CurrencyAmount? totalAmount,
    required bool isExpanded,
    required super.onPressed,
    required super.localization,
    required bool isReviewServer,
    super.key,
  }) : _monthlyAmount = monthlyAmount,
       _totalAmount = totalAmount,
       _isExpanded = isExpanded,
       _isReviewServer = isReviewServer,
       super._();

  final CurrencyAmount _monthlyAmount;
  final CurrencyAmount? _totalAmount;
  final bool _isExpanded;
  final bool _isReviewServer;

  @override
  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildMonthlyPaymentInfo(context)),
            _buildExpendedIndicator(context, _isReviewServer),
          ],
        ),
        ExpansionPanel(
          expanded: _isReviewServer || _isExpanded,
          expandedWidgets: [
            const SizedBox(height: 12),
            if (_totalAmount != null) ...[_buildTotalAmount(context), const SizedBox(height: 4)],
            _buildPaymentDescription(context, _isReviewServer),
          ],
        ),
      ],
    );
  }

  Widget _buildExpendedIndicator(BuildContext context, bool isReviewServer) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (widget, animation) {
        return ScaleTransition(scale: animation, child: widget);
      },
      child: isReviewServer
          ? Assets.images.infoVersion5.svg(key: const ValueKey('infoVersion5'))
          : _isExpanded
          ? Assets.images.chevronUp.svg(
              key: const ValueKey('close'),
              colorFilter: ColorFilter.mode(context.theme().colors.onSurfaceVariant3.shade900, BlendMode.srcIn),
            )
          : Assets.images.infoVersion5.svg(key: const ValueKey('infoVersion5')),
    );
  }

  Widget _buildMonthlyPaymentInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.body1(
          text: _localization.monthlyPayment(context),
          color: context.theme().colors.onSurfaceVariant3.shade600,
          overflow: TextOverflow.visible,
        ),
        const SizedBox(height: 4),
        Text.currency3Bold(text: _monthlyAmount.format(context, _localization.currencyLocalization)),
      ],
    );
  }

  Widget _buildTotalAmount(BuildContext context) {
    return Row(
      children: [
        Assets.images.totalAmountIcon.svg(),
        const SizedBox(width: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.caption1Regular(text: _localization.total(context)),
            const SizedBox(height: 4),
            Text.caption1Regular(text: _totalAmount!.format(context, _localization.currencyLocalization)),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentDescription(BuildContext context, bool isReviewServer) {
    return Text.caption1Regular(
      text: isReviewServer
          ? _localization.monthlyPaymentDescriptionForReviewers(
              context: context,
              dateTime: Jiffy.now().add(months: 3).dateTime.formatAsDDMMy(),
            )
          : _localization.monthlyPaymentDescription(context),
      color: context.theme().colors.onSurfaceVariant3.shade400,
      overflow: TextOverflow.visible,
    );
  }
}
