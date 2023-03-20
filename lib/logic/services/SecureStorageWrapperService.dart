import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../abstract/SecureStorageServiceA.dart';

class SecureStorageWrapperService implements SecureStorageServiceA {
  late final FlutterSecureStorage _secureStorage;
  SecureStorageWrapperService() {
    //See offical package readme
    _secureStorage = FlutterSecureStorage(
        aOptions: _getAndroidOptions(),
        iOptions: const IOSOptions(
            accessibility: KeychainAccessibility.first_unlock));
  }
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  @override
  Future<String?> read(String key) async {
    return await _secureStorage.read(key: key);
  }

  @override
  Future<void> write(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  @override
  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  @override
  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
  }
}
