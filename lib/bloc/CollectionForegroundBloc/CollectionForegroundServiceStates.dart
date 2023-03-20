import 'package:equatable/equatable.dart';

abstract class CollectionForegroundServiceState extends Equatable {}

class InitalCollectionForegroundServiceState
    extends CollectionForegroundServiceState {
  @override
  List<Object?> get props => [];
}

class CollectionForegroundServiceErrorState
    extends CollectionForegroundServiceState {
  final String errorMsg;
  final dynamic stackT;
  CollectionForegroundServiceErrorState({required this.errorMsg, this.stackT});
  @override
  List<Object?> get props => [errorMsg, stackT];
}

class CollectionForegroundServiceIsRunning
    extends CollectionForegroundServiceState {
  @override
  List<Object?> get props => [null];
}

class CollectionForegroundServiceIsNotRunning
    extends CollectionForegroundServiceState {
  @override
  List<Object?> get props => [null];
}

class HasStoppedCollectionForegroundService
    extends CollectionForegroundServiceState {
  @override
  List<Object?> get props => [];
}

class HasRestartedCollectionForegroundService
    extends CollectionForegroundServiceState {
  @override
  List<Object?> get props => [];
}

class HasStartedCollectionForegroundService
    extends CollectionForegroundServiceState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
