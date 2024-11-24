import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

Future<void> saveValue(String key, String value) async {
  await storage.write(key: key, value: value);
}

Future<String?> getValue(String key) async {
  return await storage.read(key: key);
}

Future<void> deleteValue(String key) async {
  return await storage.delete(key: key);
}
