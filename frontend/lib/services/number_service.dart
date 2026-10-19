import 'package:dio/dio.dart';

class NumberService {
  final Dio dio;

  NumberService({required this.dio});

  Future<int> generateNewNumber() async {
    try {
      final response = await dio.get(
        'http://192.168.0.56:9000/number/get_random_number',
      );
      return response.data;
    } on DioException catch (e) {
      rethrow;
    }
  }
}
