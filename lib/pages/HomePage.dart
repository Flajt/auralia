import 'package:auralia/bloc/CollectionForegroundBloc/CollectionForegroundServiceBloc.dart';
import 'package:auralia/bloc/PermissionBloc/PermissionBloc.dart';
import 'package:auralia/logic/services/PermissionService.dart';
import 'package:auralia/uiblocks/buttons/SettingsButton.dart';
import 'package:auralia/uiblocks/buttons/personalization/PersonalizationButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get_it/get_it.dart';
import '../logic/abstract/PermissionServiceA.dart';
import '../uiblocks/playerControlls/Player.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  build(BuildContext context) {
    if (GetIt.I.isRegistered<PermissionServiceA>() == false) {
      GetIt.I.registerSingleton<PermissionServiceA>(PermissionService(context));
    }
    Size size = MediaQuery.of(context).size;
    return WithForegroundTask(
      child: Scaffold(
        body: SafeArea(
            child: SizedBox.fromSize(
                size: size,
                child: Stack(children: [
                  const Align(
                      alignment: Alignment.topRight, child: SettingsButton()),
                  const Center(child: Player()),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: MultiBlocProvider(providers: [
                        BlocProvider(create: (context) => PermissionBloc()),
                        BlocProvider(
                            create: (context) => CollectionForegroundBloc())
                      ], child: const PersonalizationButton())),
                ]))),
      ),
    );
  }
}
