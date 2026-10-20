import 'package:dio/dio.dart';
import 'package:frontend/models/kaprekar_task.dart';

class NumberService {
  final Dio dio;

  NumberService({required this.dio});

  Future<KaprekarTask> getKaprekarNum({required int id}) async {
    try {
      final response = await dio.get(
        'http://192.168.0.56:9000/number/get_random_number?id=$id',
      );
      return KaprekarTask.fromMap(response.data);
    } on DioException catch (e) {
      rethrow;
    }
  }
}
