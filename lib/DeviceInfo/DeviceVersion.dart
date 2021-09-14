import 'package:device_info_plus/device_info_plus.dart';

Future<String?> getDeviceVersion() async {
  var androidInfo = await DeviceInfoPlugin().androidInfo;
  var version = androidInfo.version.release;
  return version;
}
