import 'package:equatable/equatable.dart';

class Assignment extends Equatable {
  final String id;
  final String title;
  final String course;
  final bool isCompleted;

  const Assignment({
    required this.id,
    required this.title,
    required this.course,
    this.isCompleted = false,
  });

  Assignment copyWith({String? title, String? course, bool? isCompleted}) {
    return Assignment(
      id: id,
      title: title ?? this.title,
      course: course ?? this.course,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, title, course, isCompleted];
}
