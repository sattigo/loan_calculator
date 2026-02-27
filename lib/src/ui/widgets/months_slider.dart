part of 'loan_calculator_widget.dart';

class _MonthsSlider extends BaseStatelessWidget {
  const _MonthsSlider({
    required List<LoanDuration> durations,
    LoanDuration? tempDuration,
    void Function(double value)? onChanged,
    void Function(double value)? onChangeEnd,
    String? monthsLabel,
    EdgeInsetsGeometry? labelPadding,
  }) : _monthsLabel = monthsLabel,
       _durations = durations,
       _onChanged = onChanged,
       _tempDuration = tempDuration,
       _labelPadding = labelPadding,
       _onChangeEnd = onChangeEnd;
  final String? _monthsLabel;
  final List<LoanDuration> _durations;
  final LoanDuration? _tempDuration;
  final EdgeInsetsGeometry? _labelPadding;
  final void Function(double value)? _onChanged;
  final void Function(double value)? _onChangeEnd;

  @override
  Widget build(BuildContext context) {
    final themeColors = context.theme().colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: _labelPadding ?? EdgeInsets.zero,
          child: Text.currency3Bold(text: _monthsLabel, overflow: TextOverflow.visible),
        ),
        if (_durations.length > 1) ...[
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              inactiveTrackColor: themeColors.onBackground.shade100,
              activeTrackColor: themeColors.secondary,
              inactiveTickMarkColor: themeColors.onBackground.shade300,
              activeTickMarkColor: themeColors.onPrimary,
              overlayColor: const Color(0x00007aff).withAlpha(26),
              trackShape: SliderTrackShape(),
              trackHeight: 4,
              thumbShape: SliderThumbShape(theme: context.theme()),
            ),
            child: Slider(
              divisions: _durations.length - 1,
              min: 0,
              max: _durations.length.toDouble() - 1,
              value: _durations.indexWhere((element) => element.size == _tempDuration?.size).toDouble(),
              onChanged: _onChanged ?? (_) {},
              onChangeEnd: _onChangeEnd,
            ),
          ),
        ],
      ],
    );
  }
}
