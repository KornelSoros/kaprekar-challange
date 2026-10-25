import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  final Dio dio;

  const UserService({required this.dio});

  Future<int?> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '/login',
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {'accept': '*'},
        ),
        data: {
          'grant_type': 'password',
          'username': username,
          'password': password,
          'scope': '',
        },
      );

      final accessToken = response.data['access_token'];

      final storage = FlutterSecureStorage();
      await storage.write(key: 'access_token', value: accessToken);

      return response.statusCode;
    } on DioException catch (e) {
      return e.response?.statusCode;
    }
  }
}
