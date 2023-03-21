import 'package:auralia/bloc/CollectionForegroundBloc/CollectionForegroundServiceEvents.dart';
import 'package:auralia/bloc/CollectionForegroundBloc/CollectionForegroundServiceStates.dart';
import 'package:auralia/logic/abstract/CollectionForegroundServiceA.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../logic/workerServices/ForegroundService.dart';

class CollectionForegroundBloc extends Bloc<CollectionForegroundServiceEvent,
    CollectionForegroundServiceState> {
  final _getIt = GetIt.I;
  late final CollectionForegroundServiceA _collectionForegroundServiceA;

  CollectionForegroundBloc() : super(InitalCollectionForegroundServiceState()) {
    _collectionForegroundServiceA = _getIt<CollectionForegroundServiceA>();
    _collectionForegroundServiceA.init();
    on<StartCollectionForegroundService>((event, emit) async {
      try {
        bool isRunning =
            await _collectionForegroundServiceA.startService(entryPoint);
        if (isRunning) {
          emit(HasStartedCollectionForegroundService());
        } else {
          throw "Can't start Collection Service!";
        }
      } catch (e, stackT) {
        emit(CollectionForegroundServiceErrorState(
            errorMsg: e.toString(), stackT: stackT));
      }
    });
    on<StopCollectionForegroundService>((event, emit) async {
      try {
        bool isRunning = await _collectionForegroundServiceA.stopService();
        if (isRunning) {
          emit(HasStoppedCollectionForegroundService());
        } else {
          throw "Can't stop collection service!";
        }
      } catch (e, stackT) {
        emit(CollectionForegroundServiceErrorState(
            errorMsg: e.toString(), stackT: stackT));
      }
    });
    on<RestartCollectionForegroundService>((event, emit) async {
      try {
        bool isRunning = await _collectionForegroundServiceA.restartService();
        if (isRunning) {
          emit(HasRestartedCollectionForegroundService());
        } else {
          throw "Can't restart collection service!";
        }
      } catch (e, stackT) {
        await _collectionForegroundServiceA.stopService();
        emit(CollectionForegroundServiceErrorState(
            errorMsg: e.toString(), stackT: stackT));
        emit(CollectionForegroundServiceIsNotRunning());
      }
    });
    on<IsCollectionForegroundServiceRunning>((event, emit) async {
      try {
        bool isRunning = await _collectionForegroundServiceA.isServiceRunning();
        if (isRunning) {
          emit(CollectionForegroundServiceIsRunning());
        } else {
          emit(CollectionForegroundServiceIsNotRunning());
        }
      } catch (e, stackT) {
        await _collectionForegroundServiceA.stopService();
        emit(CollectionForegroundServiceErrorState(
            errorMsg: e.toString(), stackT: stackT));
        emit(CollectionForegroundServiceIsNotRunning());
      }
    });
  }
}
