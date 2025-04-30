import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_voice_todo/models/task.dart';
import 'package:taskflow_voice_todo/providers/task_providers.dart';

class TaskList extends ConsumerWidget {
  const TaskList({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    
    if (tasks.isEmpty) {
      return const Center(
        child: Text('No tasks yet. Try adding one with voice commands!'),
      );
    }
    
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: task.description != null ? Text(task.description!) : null,
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (value) {
              if (value == true) {
                ref.read(tasksProvider.notifier).completeTask(task.id);
              } else {
                final updatedTask = Task(
                  id: task.id,
                  title: task.title,
                  description: task.description,
                  isCompleted: false,
                  createdAt: task.createdAt,
                  dueDate: task.dueDate,
                );
                ref.read(tasksProvider.notifier).updateTask(updatedTask);
              }
            },
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ref.read(tasksProvider.notifier).deleteTask(task.id);
            },
          ),
        );
      },
    );
  }
}
