import 'package:dio/dio.dart';
import 'package:frontend/models/kaprekar_task.dart';

class NumberService {
  final Dio dio;

  NumberService({required this.dio});

  Future<void> addNewKaprakarNum() async {
    try {
      final response = await dio.post(
        'http://192.168.1.23:9000/number/add_random_kaprekar',
      );
      print(response.data);
    } on DioException catch (e) {}
  }

  Future<List<KaprekarTask>> getAllKaprekarTasks() async {
    try {
      final response = await dio.get(
        'http://192.168.1.23:9000/number/all_kaprekar_tasks',
      );
      print(response.data);
      final responseList = response.data as List;
      final kaprekarTaskList = responseList
          .map((resp) => KaprekarTask.fromMap(resp))
          .toList();
      return kaprekarTaskList;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<KaprekarTask> getKaprekarNum({required int id}) async {
    try {
      final response = await dio.get(
        'http://192.168.1.23:9000/number/get_random_number?id=$id',
      );
      return KaprekarTask.fromMap(response.data);
    } on DioException catch (e) {
      rethrow;
    }
  }
}
