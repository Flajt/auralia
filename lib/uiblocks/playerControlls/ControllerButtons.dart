import 'package:auralia/bloc/PlayerBloc/PlayerBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/PlayerBloc/PlayerEvents.dart';
import '../../bloc/PlayerBloc/PlayerState.dart';

class ControllerButtons extends StatelessWidget {
  const ControllerButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerBloc = context.read<PlayerBloc>();
    return SizedBox(
      width: 300,
      child: BlocBuilder<PlayerBloc, PlayerState>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                  child: const Icon(Icons.skip_previous),
                  onPressed: () => playerBloc.add(SkipBackwards())),
              FloatingActionButton.large(
                  child: state is IsPlayingSong
                      ? const Icon(Icons.pause)
                      : const Icon(Icons.play_arrow_rounded),
                  onPressed: () => state is IsPlayingSong
                      ? playerBloc.add(Stop())
                      : playerBloc.add(Play())),
              FloatingActionButton(
                  child: const Icon(Icons.skip_next),
                  onPressed: () => playerBloc.add(SkipForward())),
            ],
          );
        },
      ),
    );
  }
}
