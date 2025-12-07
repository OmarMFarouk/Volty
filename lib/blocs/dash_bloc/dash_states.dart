abstract class DashStates {}

class DashInitial extends DashStates {}

class DashRefresh extends DashStates {}

class DashLoading extends DashStates {}

class DashLoaded extends DashStates {}

class DashSuccess extends DashStates {
  String msg = '';
  bool shouldNavigate;
  DashSuccess({required this.msg, this.shouldNavigate = true});
}

class DashError extends DashStates {
  String msg = '';
  bool shouldNavigate;
  DashError({required this.msg, this.shouldNavigate = true});
}
