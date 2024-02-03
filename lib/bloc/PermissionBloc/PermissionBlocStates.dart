import 'package:equatable/equatable.dart';

abstract class PermissionBlocState extends Equatable {}

class PermissionBlocInitialState extends PermissionBlocState {
  @override
  List<Object?> get props => [];
}

class HasAllPermissions extends PermissionBlocState {
  @override
  List<Object?> get props => [];
}

class HasNotAllPermissions extends PermissionBlocState {
  @override
  List<Object?> get props => [];
}

class PermissionBlocError extends PermissionBlocState {
  final String errorMsg;
  final dynamic stackT;
  PermissionBlocError({required this.errorMsg, this.stackT});

  @override
  List<Object?> get props => [errorMsg, stackT];
}

class GPSIsDisabled extends PermissionBlocState {
  @override
  List<Object?> get props => [];
}
