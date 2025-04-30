import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_voice_todo/models/task.dart';
import 'package:taskflow_voice_todo/services/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TasksNotifier(repository);
});

class TasksNotifier extends StateNotifier<List<Task>> {
  final TaskRepository _repository;
  
  TasksNotifier(this._repository) : super([]) {
    loadTasks();
  }
  
  void loadTasks() {
    state = _repository.getAllTasks();
  }
  
  Future<void> addTask(Task task) async {
    await _repository.addTask(task);
    loadTasks();
  }
  
  Future<void> updateTask(Task task) async {
    await _repository.updateTask(task);
    loadTasks();
  }
  
  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
    loadTasks();
  }
  
  Future<void> completeTask(String id) async {
    await _repository.completeTask(id);
    loadTasks();
  }
  
  Task? findTaskByTitle(String title) {
    return _repository.findTaskByTitle(title);
  }
}
