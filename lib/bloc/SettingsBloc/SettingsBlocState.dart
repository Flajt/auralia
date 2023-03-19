import 'package:equatable/equatable.dart';

abstract class SettingsBlocState extends Equatable {}

class InitialSettingsState extends SettingsBlocState {
  @override
  List<Object?> get props => [null];
}

class LoggingOut extends SettingsBlocState {
  @override
  List<Object?> get props => [null];
}

class IsUplodingBehaviour extends SettingsBlocState {
  @override
  List<Object?> get props => [null];
}

class ErrorUploadingBehaviour extends SettingsBlocState {
  final String errorMsg;
  final dynamic stackT;
  ErrorUploadingBehaviour({required this.errorMsg, this.stackT});
  @override
  List<Object?> get props => [errorMsg, stackT];
}

class SuccessUploadingBehaviour extends SettingsBlocState {
  @override
  List<Object?> get props => [null];
}
