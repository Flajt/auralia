import 'package:auralia/models/regular/ListeningBehaviourModel.dart';
import 'package:equatable/equatable.dart';

abstract class UserBehaviourState extends Equatable {}

class InitalUserBehaviourState extends UserBehaviourState {
  @override
  List<Object?> get props => [];
}

class HasNoUserBehaviourData extends UserBehaviourState {
  @override
  List<Object?> get props => [];
}

class HasUserBehaviourData extends UserBehaviourState {
  final DateTime? dateTime;
  final List<ListeningBehaviourModel> models;
  HasUserBehaviourData(this.dateTime, this.models);
  @override
  List<Object?> get props => [dateTime, models];
}

class UserBehaviourHasError extends UserBehaviourState {
  final String errorMsg;
  final dynamic stackT;

  UserBehaviourHasError({required this.errorMsg, this.stackT});
  @override
  List<Object?> get props => [errorMsg, stackT];
}
