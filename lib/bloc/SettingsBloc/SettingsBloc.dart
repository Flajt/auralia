import 'package:auralia/bloc/SettingsBloc/SettingsBlocEvent.dart';
import 'package:auralia/bloc/SettingsBloc/SettingsBlocState.dart';
import 'package:auralia/logic/abstract/AuthServiceA.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../logic/services/BehaviourUploadService.dart';

class SettingsBloc extends Bloc<SettingsBlocEvent, SettingsBlocState> {
  late final AuthServiceA _authService;
  late final _getIt = GetIt.I;

  SettingsBloc() : super(InitialSettingsState()) {
    _authService = _getIt<AuthServiceA>();

    on<UploadBehaviour>(_uploadBehaviour);
    on<LogOut>(_logOut);
  }
  Future<void> _uploadBehaviour(
      SettingsBlocEvent event, Emitter emitter) async {
    try {
      final service = BehaviourUploadService(
          getIt: _getIt, baseUrl: "https://auralia.fly.dev");
      bool hasUploaded = await service.uploadSongs();
      if (hasUploaded) {
        emitter(SuccessUploadingBehaviour());
      } else {
        emitter(ErrorUploadingBehaviour(
            errorMsg: "You didn't listen to any new songs"));
      }
    } catch (e, stackT) {
      emitter(ErrorUploadingBehaviour(errorMsg: e.toString(), stackT: stackT));
    }
  }

  void _logOut(SettingsBlocEvent event, Emitter emitter) async {
    await _authService.signOut();
    emitter(LoggingOut());
  }
}
