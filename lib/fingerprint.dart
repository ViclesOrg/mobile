import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceFingerprint {
  static Future<String> generate() async {
    final deviceInfo = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();
    Map<String, dynamic> deviceData = {};

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceData = {
          'platform': 'android',
          'version.securityPatch': androidInfo.version.securityPatch,
          'version.sdkInt': androidInfo.version.sdkInt,
          'version.release': androidInfo.version.release,
          'version.codename': androidInfo.version.codename,
          'board': androidInfo.board,
          'bootloader': androidInfo.bootloader,
          'brand': androidInfo.brand,
          'device': androidInfo.device,
          'display': androidInfo.display,
          'fingerprint': androidInfo.fingerprint,
          'hardware': androidInfo.hardware,
          'host': androidInfo.host,
          'id': androidInfo.id,
          'manufacturer': androidInfo.manufacturer,
          'model': androidInfo.model,
          'product': androidInfo.product,
          'supported32BitAbis': androidInfo.supported32BitAbis,
          'supported64BitAbis': androidInfo.supported64BitAbis,
          'supportedAbis': androidInfo.supportedAbis,
          'tags': androidInfo.tags,
          'type': androidInfo.type,
          'isPhysicalDevice': androidInfo.isPhysicalDevice,
          'systemFeatures': androidInfo.systemFeatures,
        };
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceData = {
          'platform': 'ios',
          'name': iosInfo.name,
          'systemName': iosInfo.systemName,
          'systemVersion': iosInfo.systemVersion,
          'model': iosInfo.model,
          'localizedModel': iosInfo.localizedModel,
          'identifierForVendor': iosInfo.identifierForVendor,
          'isPhysicalDevice': iosInfo.isPhysicalDevice,
          'utsname.sysname': iosInfo.utsname.sysname,
          'utsname.nodename': iosInfo.utsname.nodename,
          'utsname.release': iosInfo.utsname.release,
          'utsname.version': iosInfo.utsname.version,
          'utsname.machine': iosInfo.utsname.machine,
        };
      } else if (kIsWeb) {
        final webInfo = await deviceInfo.webBrowserInfo;
        deviceData = {
          'platform': 'web',
          'browserName': webInfo.browserName,
          'appCodeName': webInfo.appCodeName,
          'appName': webInfo.appName,
          'appVersion': webInfo.appVersion,
          'deviceMemory': webInfo.deviceMemory,
          'language': webInfo.language,
          'languages': webInfo.languages,
          'platform': webInfo.platform,
          'product': webInfo.product,
          'productSub': webInfo.productSub,
          'userAgent': webInfo.userAgent,
          'vendor': webInfo.vendor,
          'vendorSub': webInfo.vendorSub,
          'hardwareConcurrency': webInfo.hardwareConcurrency,
          'maxTouchPoints': webInfo.maxTouchPoints,
        };
      }

      // Add package info
      deviceData.addAll({
        'appName': packageInfo.appName,
        'packageName': packageInfo.packageName,
        'version': packageInfo.version,
        'buildNumber': packageInfo.buildNumber,
      });

      // Generate fingerprint
      final String jsonData = json.encode(deviceData);
      final List<int> bytes = utf8.encode(jsonData);
      final Digest digest = sha256.convert(bytes);
      
      return digest.toString();
    } catch (e) {
      debugPrint('Error generating device fingerprint: $e');
      // Fallback fingerprint generation
      return _generateFallbackFingerprint();
    }
  }

  static String _generateFallbackFingerprint() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecondsSinceEpoch;
    final fallbackData = 'fallback_$timestamp$random';
    final bytes = utf8.encode(fallbackData);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}