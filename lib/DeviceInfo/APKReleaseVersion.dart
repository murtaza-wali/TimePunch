import 'dart:io';
import 'package:package_info/package_info.dart';

Future<String> getAPKReleaseVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  var version;
  if (Platform.isAndroid) {
    version = packageInfo.version;
    print('Android release $version');
    // Android 9 (SDK 28), Xiaomi Redmi Note 7
  }

  if (Platform.isIOS) {
    version = packageInfo.version;
    print('IOS release $version');

    // iOS 13.1, iPhone 11 Pro Max iPhone
  }
  print("deviceIdentifier :- " + version.toString());

  return version;
}

Future<String> getAPKBuildNum() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  var version;
  if (Platform.isAndroid) {
    version = packageInfo.buildNumber;
    // Android 9 (SDK 28), Xiaomi Redmi Note 7
  }

  if (Platform.isIOS) {
    version = packageInfo.version;
    print('IOS release $version');
    // iOS 13.1, iPhone 11 Pro Max iPhone
  }
  print("deviceIdentifier :- " + version.toString());

  return version;
}
