import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';

class UserService {
  final Dio dio;

  const UserService({required this.dio});

  Future<void> register(User user) async {
    await dio.post("/register", data: user.toMap());
  }

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

  Future<UserPublic> getCurrentUser() async {
    final response = await dio.get('/me');
    final responseUser = response.data;
    return UserPublic.fromMap(responseUser);
  }

  Future<void> logout() async {
    await dio.post('/logout');
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'access_token');
  }
}
