import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_voice_todo/models/task.dart';
import 'package:taskflow_voice_todo/providers/feedback_provider.dart';
import 'package:taskflow_voice_todo/providers/task_providers.dart';
import 'package:taskflow_voice_todo/services/command_parser.dart';
import 'package:taskflow_voice_todo/services/speech_service.dart';
import 'package:taskflow_voice_todo/widgets/task_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final SpeechService _speechService = SpeechService();
  final CommandParser _commandParser = CommandParser();
  bool _isListening = false;
  String _lastCommand = '';
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeSpeech();

    // Speak a welcome message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final feedbackService = ref.read(feedbackServiceProvider);
      feedbackService.speak(
          'Welcome to TaskFlow. Tap the microphone to start giving voice commands.');
    });
  }

  Future<void> _initializeSpeech() async {
    await _speechService.initialize();
  }

  void _listenForCommand() async {
    final feedbackService = ref.read(feedbackServiceProvider);

    setState(() {
      _isListening = true;
      _statusMessage = 'Listening...';
    });

    feedbackService.speak('Listening');

    await _speechService.listen(
      onResult: (text) {
        setState(() {
          _lastCommand = text;
          _statusMessage = 'Processing: "$text"';
        });

        final command = _commandParser.parse(text);
        _handleCommand(command);
      },
      onListeningComplete: () {
        setState(() {
          _isListening = false;
        });
      },
    );
  }

  void _handleCommand(CommandResult command) {
    final tasksNotifier = ref.read(tasksProvider.notifier);
    final feedbackService = ref.read(feedbackServiceProvider);

    switch (command.type) {
      case CommandType.add:
        final title = command.parameters['title'] ?? '';
        if (title.isEmpty) {
          _setStatusMessage('Please specify a task title');
          feedbackService.speak('Please specify a task title');
          return;
        }

        final task = Task(title: title);
        tasksNotifier.addTask(task);
        _setStatusMessage('Added task: $title');
        feedbackService.speak('Added task: $title');
        break;

      case CommandType.complete:
        final title = command.parameters['title'] ?? '';
        if (title.isEmpty) {
          _setStatusMessage('Please specify which task to complete');
          feedbackService.speak('Please specify which task to complete');
          return;
        }

        final task = tasksNotifier.findTaskByTitle(title);
        if (task == null) {
          _setStatusMessage('Could not find a task named "$title"');
          feedbackService.speak('Could not find a task named "$title"');
          return;
        }

        tasksNotifier.completeTask(task.id);
        _setStatusMessage('Completed task: ${task.title}');
        feedbackService.speak('Completed task: ${task.title}');
        break;

      case CommandType.delete:
        final title = command.parameters['title'] ?? '';
        if (title.isEmpty) {
          _setStatusMessage('Please specify which task to delete');
          feedbackService.speak('Please specify which task to delete');
          return;
        }

        final task = tasksNotifier.findTaskByTitle(title);
        if (task == null) {
          _setStatusMessage('Could not find a task named "$title"');
          feedbackService.speak('Could not find a task named "$title"');
          return;
        }

        tasksNotifier.deleteTask(task.id);
        _setStatusMessage('Deleted task: ${task.title}');
        feedbackService.speak('Deleted task: ${task.title}');
        break;

      case CommandType.list:
        final tasks = ref.read(tasksProvider);
        if (tasks.isEmpty) {
          _setStatusMessage('You have no tasks');
          feedbackService.speak('You have no tasks');
        } else {
          _setStatusMessage('Displaying all tasks');
          feedbackService.speak('You have ${tasks.length} tasks');
        }
        break;

      case CommandType.unknown:
        _setStatusMessage('Sorry, I didn\'t understand that command');
        feedbackService.speak(
            'Sorry, I didn\'t understand that command. Please try again.');
        break;
    }
  }

  void _setStatusMessage(String message) {
    setState(() {
      _statusMessage = message;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow Voice Todo'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.blue.shade50,
            child: Column(
              children: [
                Text(
                  _statusMessage,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16.0,
                  ),
                ),
                if (_lastCommand.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Last command: "$_lastCommand"',
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: const TaskList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _listenForCommand,
        tooltip: 'Voice Command',
        icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
        backgroundColor: _isListening ? Colors.red : null,
        label: Text(_isListening ? 'Stop' : 'Speak'),
      ),
    );
  }
}
