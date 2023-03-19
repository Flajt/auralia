import 'package:auralia/bloc/SignInBloc/SignInEvents.dart';
import 'package:auralia/bloc/SignInBloc/SignInState.dart';
import 'package:auralia/logic/abstract/AuthServiceA.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import "package:get_it/get_it.dart";

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final getIt = GetIt.instance;
  late final AuthServiceA _authServiceA;
  late final ChromeSafariBrowser _chromeSafariBrowser;
  SignInBloc() : super(InitialAuthState()) {
    _authServiceA = getIt<AuthServiceA>();
    _chromeSafariBrowser = getIt<ChromeSafariBrowser>();
    on<SignInEvent>(_signInWithOauth);
  }

  Future<void> _signInWithOauth(
      SignInEvent event, Emitter<SignInState> emit) async {
    try {
      emit(AttemptSignIn());
      String url = await _authServiceA.getSignInUrl();
      await _chromeSafariBrowser.open(
          url: Uri.parse(url),
          options: ChromeSafariBrowserClassOptions(
              android: AndroidChromeCustomTabsOptions(
                  shareState: CustomTabsShareState.SHARE_STATE_OFF,
                  isSingleInstance: true)));
      emit(HasSignedIn());
    } catch (e, stackT) {
      emit(SignInError(errorMsg: e.toString(), stackTrace: stackT));
    }
  }
}
