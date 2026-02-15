abstract class AnalyticsStates {}

class AnalyticsInitial extends AnalyticsStates {}

class AnalyticsRefresh extends AnalyticsStates {}

class AnalyticsLoading extends AnalyticsStates {}

class AnalyticsLoaded extends AnalyticsStates {}

class AnalyticsSuccess extends AnalyticsStates {
  String msg = '';
  bool shouldNavigate;
  AnalyticsSuccess({required this.msg, this.shouldNavigate = true});
}

class AnalyticsError extends AnalyticsStates {
  String msg = '';
  bool shouldNavigate;
  AnalyticsError({required this.msg, this.shouldNavigate = true});
}
