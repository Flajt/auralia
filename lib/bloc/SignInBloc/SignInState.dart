import 'package:equatable/equatable.dart';

abstract class SignInState extends Equatable {}

class InitialAuthState extends SignInState {
  @override
  List<Object?> get props => [null];
}

class AttemptSignIn extends SignInState {
  @override
  List<Object?> get props => [null];
}

class HasSignedIn extends SignInState {
  @override
  List<Object?> get props => [null];
}

class SignInError extends SignInState {
  final String errorMsg;
  final dynamic stackTrace;
  SignInError({required this.errorMsg, required this.stackTrace});

  @override
  List<Object?> get props => [errorMsg, stackTrace];
}
