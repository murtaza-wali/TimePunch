import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

Future<String> getDeviceIdentifier() async {
  String deviceIdentifier = "unknown";
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceIdentifier = androidInfo.androidId!;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceIdentifier = iosInfo.identifierForVendor!;
  }
  print("deviceIdentifier :- " + deviceIdentifier.toString());

  return deviceIdentifier;
}
