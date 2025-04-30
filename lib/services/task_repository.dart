import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskflow_voice_todo/models/task.dart';

class TaskRepository {
  final Box<Task> _taskBox = Hive.box<Task>('tasks');
  
  List<Task> getAllTasks() {
    return _taskBox.values.toList();
  }
  
  Future<String> addTask(Task task) async {
    await _taskBox.put(task.id, task);
    return task.id;
  }
  
  Future<void> updateTask(Task task) async {
    await _taskBox.put(task.id, task);
  }
  
  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
  }
  
  Future<void> completeTask(String id) async {
    final task = _taskBox.get(id);
    if (task != null) {
      task.isCompleted = true;
      await _taskBox.put(id, task);
    }
  }
  
 Task findTaskByTitle(String title) {
    return _taskBox.values.firstWhere(
        (task) => task.title.toLowerCase().contains(title.toLowerCase()),
        orElse: () => Task(id: 'default', title: 'Not Found'), // Provide a default Task or handle it differently
    );
}

  
  List<Task> searchTasks(String query) {
    if (query.isEmpty) return getAllTasks();
    
    return _taskBox.values
        .where((task) => 
            task.title.toLowerCase().contains(query.toLowerCase()) ||
            (task.description?.toLowerCase().contains(query.toLowerCase()) ?? false))
        .toList();
  }
}
