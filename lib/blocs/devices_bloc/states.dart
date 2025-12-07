abstract class DevicesStates {}

class DevicesInitial extends DevicesStates {}

class DevicesRefresh extends DevicesStates {}

class DevicesLoading extends DevicesStates {}

class DevicesLoaded extends DevicesStates {}

class DevicesSuccess extends DevicesStates {
  String msg = '';
  bool shouldNavigate;
  DevicesSuccess({required this.msg, this.shouldNavigate = true});
}

class DevicesError extends DevicesStates {
  String msg = '';
  bool shouldNavigate;
  DevicesError({required this.msg, this.shouldNavigate = true});
}
