import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageWrapperService {
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
  Future<String?> read(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> write(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
  }
}
