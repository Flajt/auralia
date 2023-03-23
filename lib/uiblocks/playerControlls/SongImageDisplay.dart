import 'package:auralia/logic/abstract/MusicServiceA.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../bloc/PlayerBloc/PlayerBloc.dart';
import '../../bloc/PlayerBloc/PlayerState.dart';

class SongImgeDisplay extends StatelessWidget {
  const SongImgeDisplay({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      buildWhen: (prev, current) {
        if (getUri(prev) != getUri(current)) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return Card(
            elevation: 10.0,
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(),
              child: AnimatedSwitcher(
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  duration: const Duration(seconds: 3),
                  child: FutureBuilder(
                      key: ValueKey(getUri(state)),
                      future: GetIt.I<MusicServiceA>()
                          .getImage(getUri(state) ?? ""),
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          return Image.memory(snapshot.data!);
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator.adaptive());
                        } else {
                          return const Icon(Icons.question_mark, size: 100);
                        }
                      }))),
            ));
      },
    );
  }

  String? getUri(PlayerState state) {
    if (state is IsPlayingSong) {
      return state.playerState.imageUri;
    } else if (state is IsPaused) {
      return state.playerState.imageUri;
    } else if (state is HasSkippedBackwards) {
      return state.playerState.imageUri;
    } else if (state is HasSkippedForward) {
      return state.playerState.imageUri;
    }
    return null;
  }
}
