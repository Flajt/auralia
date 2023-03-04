import 'package:auralia/uiblocks/buttons/SpotifyButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: SizedBox(
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Experience The Right Music At The Right Time",
              style: Theme.of(context)
                  .textTheme
                  .headline3
                  ?.copyWith(color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SvgPicture.asset(
              "assets/listeningToMusic.svg",
              height: size.height * .4,
            ),
            const SpotifyButton()
          ],
        ),
      ),
    ));
  }
}
