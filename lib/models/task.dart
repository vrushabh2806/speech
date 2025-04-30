import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  String title;
  
  @HiveField(2)
  String? description;
  
  @HiveField(3)
  bool isCompleted;
  
  @HiveField(4)
  DateTime createdAt;
  
  @HiveField(5)
  DateTime? dueDate;
  
  Task({
    String? id,
    required this.title,
    this.description,
    this.isCompleted = false,
    DateTime? createdAt,
    this.dueDate,
  }) : 
    id = id ?? const Uuid().v4(),
    createdAt = createdAt ?? DateTime.now();
}
