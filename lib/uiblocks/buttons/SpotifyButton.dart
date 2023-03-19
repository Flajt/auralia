import 'package:auralia/bloc/SignInBloc/SignInBloc.dart';
import 'package:auralia/bloc/SignInBloc/SignInEvents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';

class SpotifyButton extends StatelessWidget {
  const SpotifyButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignInBloc bloc = context.read<SignInBloc>();
    return ElevatedButton.icon(
      onPressed: () async => bloc.add(const SignInWithOauth()),
      icon: const Icon(LineIcons.spotify, size: 35),
      label: const Text("Sign In With Spotify"),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff1db954),
        elevation: 3,
        textStyle: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
        foregroundColor: Colors.black,
        shadowColor: Colors.grey,
      ),
    );
  }
}
