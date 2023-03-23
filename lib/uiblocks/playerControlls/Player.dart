import 'package:auralia/uiblocks/playerControlls/ControllerButtons.dart';
import 'package:auralia/uiblocks/playerControlls/SongImageDisplay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/PlayerBloc/PlayerBloc.dart';
import '../../bloc/PlayerBloc/PlayerEvents.dart';
import '../../bloc/PlayerBloc/PlayerState.dart';

class Player extends StatelessWidget {
  const Player({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PlayerBloc>();
    if (bloc.state is InitalPlayerState) {
      bloc.add(InitPlayer());
    }
    return SizedBox(
      width: 400,
      height: 500,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [SongImgeDisplay(), ControllerButtons()]),
    );
  }
}
