import 'package:auralia/bloc/CollectionForegroundBloc/CollectionForegroundServiceBloc.dart';
import 'package:auralia/bloc/CollectionForegroundBloc/CollectionForegroundServiceEvents.dart';
import 'package:auralia/bloc/PermissionBloc/PermissionBlocStates.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/CollectionForegroundBloc/CollectionForegroundServiceStates.dart';
import '../../../bloc/PermissionBloc/PermissionBloc.dart';
import '../../../bloc/PermissionBloc/PermissionBlocEvents.dart';

class PersonalizationButton extends StatelessWidget {
  const PersonalizationButton({
    super.key,
  });
  @override
  build(BuildContext context) {
    context
        .read<CollectionForegroundBloc>()
        .add(IsCollectionForegroundServiceRunning());
    return BlocListener<PermissionBloc, PermissionBlocState>(
      listener: (context, state) async {
        if (state is HasNotAllPermissions) {
          // ignore: use_build_context_synchronously
          ElegantNotification.error(
                  description:
                      const Text("All services are required, pelase try again"))
              .show(context);
        } else if (state is GPSIsDisabled) {
          ElegantNotification.info(
              description: Text(
            "Please enable your GPS!",
            style: Theme.of(context).textTheme.bodyLarge,
          )).show(context);
        } else if (state is HasAllPermissions) {
          final bloc = context.read<CollectionForegroundBloc>();
          if (bloc.state is CollectionForegroundServiceIsRunning) {
            bloc.add(StopCollectionForegroundService());
          } else {
            bloc.add(StartCollectionForegroundService());
          }
        }
      },
      child: BlocConsumer<CollectionForegroundBloc,
          CollectionForegroundServiceState>(
        buildWhen: (prev, curr) => true,
        listener: (context, state) {
          if (state is CollectionForegroundServiceErrorState) {
            ElegantNotification.error(description: Text(state.errorMsg))
                .show(context);
          }
        },
        builder: (context, state) {
          return OutlinedButton(
            onPressed: () async {
              if (isActive(state)) {
                context
                    .read<CollectionForegroundBloc>()
                    .add(StopCollectionForegroundService());
              } else {
                context.read<PermissionBloc>().add(HasPermissions());
              }
            },
            style: isActive(state)
                ? OutlinedButton.styleFrom(foregroundColor: Colors.redAccent)
                : null,
            child:
                Text("${isActive(state) ? "Stop" : "Enable"} personalization"),
          );
        },
      ),
    );
  }

  bool isActive(CollectionForegroundServiceState state) {
    if (state is CollectionForegroundServiceIsRunning) {
      return true;
    } else if (state is CollectionForegroundServiceIsNotRunning) {
      return false;
    } else if (state is HasRestartedCollectionForegroundService) {
      return true;
    } else if (state is HasStartedCollectionForegroundService) {
      return true;
    }
    return false;
  }
}
