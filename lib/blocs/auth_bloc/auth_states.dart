abstract class AuthStates {}

class AuthInitial extends AuthStates {}

class AuthRefresh extends AuthStates {}

class AuthLoading extends AuthStates {}

class AuthLoaded extends AuthStates {}

class AuthSuccess extends AuthStates {
  String msg = '';
  bool shouldNavigate;
  AuthSuccess({required this.msg, this.shouldNavigate = true});
}

class AuthError extends AuthStates {
  String msg = '';
  bool shouldNavigate;
  AuthError({required this.msg, this.shouldNavigate = true});
}
