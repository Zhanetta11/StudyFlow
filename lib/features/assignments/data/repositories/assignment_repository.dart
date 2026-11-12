import 'package:dio/dio.dart';

import '../../../../core/network/api_config.dart';
import '../models/assignment.dart';

class AssignmentRepository {
  final Dio _dio;

  AssignmentRepository({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiConfig.baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  // GET - Load all assignments
  Future<List<Assignment>> getAssignments() async {
    final response = await _dio.get('/assignments');

    final data = response.data as List<dynamic>;

    return data
        .map((item) => Assignment.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // POST - Create a new assignment
  Future<Assignment> createAssignment({
    required String title,
    required String course,
  }) async {
    final response = await _dio.post(
      '/assignments',
      data: {'title': title, 'course': course, 'completed': false},
    );

    return Assignment.fromJson(response.data as Map<String, dynamic>);
  }

  // PUT - Update an existing assignment
  Future<Assignment> updateAssignment(Assignment assignment) async {
    final response = await _dio.put(
      '/assignments/${assignment.id}',
      data: {
        'title': assignment.title,
        'course': assignment.course,
        'completed': assignment.isCompleted,
      },
    );

    return Assignment.fromJson(response.data as Map<String, dynamic>);
  }

  // DELETE - Remove an assignment
  Future<void> deleteAssignment(String id) async {
    await _dio.delete('/assignments/$id');
  }
}
