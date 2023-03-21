import 'package:auralia/bloc/UserBehaviourBloc/UserBehaviourEvents.dart';
import 'package:auralia/bloc/UserBehaviourBloc/UserBehaviourStates.dart';
import 'package:auralia/logic/abstract/BehaviourUploadServiceA.dart';
import 'package:auralia/logic/abstract/DBServiceA.dart';
import 'package:auralia/models/regular/ListeningBehaviourModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class UserBehaviourBloc extends Bloc<UserBehaviourEvent, UserBehaviourState> {
  final _getIt = GetIt.I;
  late final DBServiceA _dbService;
  late final BehaviourUploadServiceA behaviourUploadService;
  UserBehaviourBloc() : super(InitalUserBehaviourState()) {
    _dbService = _getIt<DBServiceA>();
    behaviourUploadService = _getIt<BehaviourUploadServiceA>();
    on<GetUserData>(_getData);
  }

  void _getData(UserBehaviourEvent event, Emitter emitter) async {
    try {
      DateTime? dateTime;
      List<ListeningBehaviourModel> models = await _dbService.getAll();
      if (models.isNotEmpty) {
        int? dateTimeMs = await behaviourUploadService.recentUploadTime;
        if (dateTimeMs != null) {
          dateTime = DateTime.fromMillisecondsSinceEpoch(dateTimeMs);
        }
        emitter(HasUserBehaviourData(dateTime, models));
      } else {
        emitter(HasNoUserBehaviourData());
      }
    } catch (e, stackT) {
      emitter(UserBehaviourHasError(errorMsg: e.toString(), stackT: stackT));
    }
  }
}
