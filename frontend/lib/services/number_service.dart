import 'package:dio/dio.dart';
import 'package:frontend/models/kaprekar_task.dart';

class NumberService {
  final Dio dio;

  NumberService({required this.dio});

  Future<void> addNewKaprakarNum() async {
    try {
      final response = await dio.post('/add_random_kaprekar');
    } on DioException catch (e) {}
  }

  Future<List<KaprekarTask>> getAllKaprekarTasks() async {
    try {
      final response = await dio.get('/all_kaprekar_tasks');
      final responseList = response.data as List;
      final kaprekarTaskList = responseList
          .map((resp) => KaprekarTask.fromMap(resp))
          .toList();
      return kaprekarTaskList;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<List<KaprekarTask>> getKaprekarTasksByUserId() async {
    try {
      final response = await dio.get('/kaprekar_tasks_by_user_id');
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
      final response = await dio.get('/get_random_number?id=$id');
      return KaprekarTask.fromMap(response.data);
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<void> sendSolution({
    required int id,
    required List<List<int>> solutionSteps,
  }) async {
    print(solutionSteps);
    try {
      await dio.put(
        '/send_solution?kaprekar_id=$id',
        data: solutionSteps,
        options: Options(contentType: Headers.jsonContentType),
      );
    } on DioException catch (e) {
      print("FASTAPI HIBA: ${e.response?.data}");
      rethrow;
    }
  }
}
