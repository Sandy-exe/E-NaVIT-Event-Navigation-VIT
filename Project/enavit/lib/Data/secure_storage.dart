import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage{

  // AndroidOptions _getAndroidOptions() => const AndroidOptions(
  //       encryptedSharedPreferences: true,
  //     );

  final storage = const FlutterSecureStorage();

  Future<void> writer({required String key, required String value}) async {
    await storage.write(key: key, value: value);
  }

  Future<String?> reader({required String key}) async {
    String? value = await storage.read(key: key);
    return value;
  }

  Future<void> clear({String? key}) async {
    if (key == null) {
      await storage.deleteAll();
    } else {
      await storage.delete(key: key);
    }
  }

}

