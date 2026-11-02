import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppUpdate {
  final String version;
  final int buildNumber;
  final String downloadUrl;
  final String releaseNotes;
  final bool mandatory;

  AppUpdate({
    required this.version,
    required this.buildNumber,
    required this.downloadUrl,
    required this.releaseNotes,
    required this.mandatory,
  });

  factory AppUpdate.fromJson(Map<String, dynamic> json) {
    return AppUpdate(
      version: json['version'] as String,
      buildNumber: (json['build_number'] as num).toInt(),
      downloadUrl: json['download_url'] as String,
      releaseNotes: json['release_notes'] as String? ?? '',
      mandatory: json['mandatory'] as bool? ?? false,
    );
  }
}

class AppUpdateService {
  static const String versionUrl =
      'https://storage.googleapis.com/'
      'kaprekar-app-updates/android/version.json';

  final Dio dio;

  AppUpdateService(this.dio);

  Future<AppUpdate?> checkForUpdate() async {
    final packageInfo = await PackageInfo.fromPlatform();

    final currentBuild = int.parse(packageInfo.buildNumber);

    final response = await dio.get(
      versionUrl,
      options: Options(
        responseType: ResponseType.json,
        headers: {'Cache-Control': 'no-cache'},
      ),
    );

    final update = AppUpdate.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );

    if (update.buildNumber > currentBuild) {
      return update;
    }

    return null;
  }
}
