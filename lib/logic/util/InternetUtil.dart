import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetUtil {
  static Future<bool> hasInternet() async =>
      await InternetConnectionChecker().hasConnection;

  static Stream<InternetConnectionStatus> connectionStateStream() =>
      InternetConnectionChecker().onStatusChange;
}
