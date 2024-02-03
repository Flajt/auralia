import 'package:auralia/bloc/PermissionBloc/PermissionBlocEvents.dart';
import 'package:auralia/bloc/PermissionBloc/PermissionBlocStates.dart';
import 'package:auralia/logic/abstract/PermissionServiceA.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class PermissionBloc extends Bloc<PermissionBlocEvent, PermissionBlocState> {
  final _getIt = GetIt.I;
  late final PermissionServiceA _permissionService;
  PermissionBloc() : super(PermissionBlocInitialState()) {
    _permissionService = _getIt<PermissionServiceA>();
    on<HasPermissions>(_hasPermissions);
  }

  Future<void> _hasPermissions(
      PermissionBlocEvent event, Emitter emitter) async {
    try {
      bool hasAll = await _hasAllPermissions();
      bool gpsEnabled = await _permissionService.hasEnabledGPS();
      if (hasAll && gpsEnabled) {
        emitter(HasAllPermissions());
        emitter(PermissionBlocInitialState());
      } else if (!hasAll) {
        emitter(HasNotAllPermissions());
        emitter(PermissionBlocInitialState());
      } else if (!gpsEnabled) {
        emitter(GPSIsDisabled());
        emitter(PermissionBlocInitialState());
      }
    } catch (e, stackT) {
      emitter(PermissionBlocError(errorMsg: e.toString(), stackT: stackT));
      emitter(PermissionBlocInitialState());
    }
  }

  Future<bool> _hasAllPermissions() async {
    bool activityEnabled =
        await _permissionService.reqeuestActivityRecognition();
    bool locationEnabled = await _permissionService.requestLocationAccess();
    bool backgroundLocationEnabled =
        await _permissionService.requestBackgroundLocationAccess();
    bool notificationEnabled =
        await _permissionService.requestNotificationPermission();
    return ![
      activityEnabled,
      locationEnabled,
      backgroundLocationEnabled,
      notificationEnabled
    ].any((element) => element == false);
  }
}
