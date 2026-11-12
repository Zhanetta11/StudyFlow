import 'package:equatable/equatable.dart';

class Assignment extends Equatable {
  final String id;
  final String title;
  final String course;
  final bool isCompleted;
  final DateTime? dueDate;

  const Assignment({
    required this.id,
    required this.title,
    required this.course,
    this.isCompleted = false,
    this.dueDate,
  });

  Assignment copyWith({
    String? title,
    String? course,
    bool? isCompleted,
    DateTime? dueDate,
  }) {
    return Assignment(
      id: id,
      title: title ?? this.title,
      course: course ?? this.course,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'].toString(),
      title: json['title'] as String,
      course: json['course'] as String,
      isCompleted: json['completed'] as bool,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'course': course,
      'completed': isCompleted,
      'dueDate': dueDate != null
          ? '${dueDate!.year.toString().padLeft(4, '0')}-'
                '${dueDate!.month.toString().padLeft(2, '0')}-'
                '${dueDate!.day.toString().padLeft(2, '0')}'
          : null,
    };
  }

  @override
  List<Object?> get props => [id, title, course, isCompleted, dueDate];
}
