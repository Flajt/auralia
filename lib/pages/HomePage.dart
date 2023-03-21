import 'dart:async';
import 'package:auralia/bloc/CollectionForegroundBloc/CollectionForegroundServiceBloc.dart';
import 'package:auralia/bloc/PermissionBloc/PermissionBloc.dart';
import 'package:auralia/logic/services/PermissionService.dart';
import 'package:auralia/logic/util/InternetUtil.dart';
import 'package:auralia/uiblocks/buttons/SettingsButton.dart';
import 'package:auralia/uiblocks/buttons/personalization/PersonalizationButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../logic/abstract/PermissionServiceA.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final StreamSubscription _netSubscription;
  _HomePageState() {
    _netSubscription =
        InternetUtil.connectionStateStream().listen((event) async {
      bool hasNet = event == InternetConnectionStatus.connected;
      await Sentry.addBreadcrumb(Breadcrumb(
          message: "HomePage Internet Check",
          data: {"hasNet": hasNet},
          level: SentryLevel.info));
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _netSubscription.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (GetIt.I.isRegistered<PermissionServiceA>() == false) {
      GetIt.I.registerSingleton<PermissionServiceA>(PermissionService(context));
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WithForegroundTask(
      child: Scaffold(
        body: SafeArea(
            child: SizedBox.fromSize(
                size: size,
                child: Stack(children: [
                  const Align(
                      alignment: Alignment.topRight, child: SettingsButton()),
                  Center(
                      child: Text(
                          "This app currently only collects data, more features comming soon.",
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center)),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: MultiBlocProvider(
                        providers: [
                          BlocProvider(create: (context) => PermissionBloc()),
                          BlocProvider(
                              create: (context) => CollectionForegroundBloc())
                        ],
                        child: const PersonalizationButton(),
                      ))
                ]))),
      ),
    );
  }
}
