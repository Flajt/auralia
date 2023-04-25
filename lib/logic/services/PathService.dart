import 'dart:io';

import '../abstract/PathSeriveA.dart';
import 'package:path_provider/path_provider.dart';

class PathService extends PathServiceA {
  Directory? _appDocDir;
  Directory? _appSupDir;
  @override
  String get appDocPath => _appDocDir!.path;

  @override
  String get appSupPath => _appSupDir!.path;

  @override
  Future<void> init() async {
    _appDocDir = await getApplicationDocumentsDirectory();
    _appSupDir = await getApplicationSupportDirectory();
  }
}
