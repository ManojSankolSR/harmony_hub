import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermissions {
  static Future<PermissionStatus> requestStoragePermissions() async {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var release = double.parse(androidInfo.version.release);

    if (release >= 13) {
      return await Permission.manageExternalStorage.request();
    } else {
      return await Permission.storage.request();
    }
  }

  static Future<PermissionStatus> requestAudioPermission() async {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var release = double.parse(androidInfo.version.release);
    if (release >= 13) {
      return await Permission.audio.request();
    } else {
      return PermissionStatus.granted;
    }
  }
}
