class CommandParser {
  static const List<String> _addCommands = [
    'add', 'create', 'new', 'make'
  ];
  
  static const List<String> _completeCommands = [
    'complete', 'finish', 'done', 'mark as done', 'completed'
  ];
  
  static const List<String> _deleteCommands = [
    'delete', 'remove', 'erase'
  ];
  
  static const List<String> _listCommands = [
    'list', 'show', 'display', 'what are my tasks'
  ];
  
  CommandResult parse(String text) {
    final lowercaseText = text.toLowerCase();
    
    // Check for add command
    for (final cmd in _addCommands) {
      if (lowercaseText.startsWith('$cmd ') || lowercaseText == cmd) {
        final taskTitle = lowercaseText.startsWith('$cmd ')
            ? lowercaseText.substring(cmd.length).trim()
            : '';
        return CommandResult(
          type: CommandType.add,
          parameters: {'title': taskTitle},
        );
      }
    }
    
    // Check for complete command
    for (final cmd in _completeCommands) {
      if (lowercaseText.startsWith('$cmd ') || lowercaseText == cmd) {
        final taskTitle = lowercaseText.startsWith('$cmd ')
            ? lowercaseText.substring(cmd.length).trim()
            : '';
        return CommandResult(
          type: CommandType.complete,
          parameters: {'title': taskTitle},
        );
      }
    }
    
    // Check for delete command
    for (final cmd in _deleteCommands) {
      if (lowercaseText.startsWith('$cmd ') || lowercaseText == cmd) {
        final taskTitle = lowercaseText.startsWith('$cmd ')
            ? lowercaseText.substring(cmd.length).trim()
            : '';
        return CommandResult(
          type: CommandType.delete,
          parameters: {'title': taskTitle},
        );
      }
    }
    
    // Check for list command
    for (final cmd in _listCommands) {
      if (lowercaseText.contains(cmd)) {
        return CommandResult(
          type: CommandType.list,
          parameters: {},
        );
      }
    }
    
    // Unknown command
    return CommandResult(
      type: CommandType.unknown,
      parameters: {'text': lowercaseText},
    );
  }
}

enum CommandType {
  add,
  complete,
  delete,
  list,
  unknown,
}

class CommandResult {
  final CommandType type;
  final Map<String, String> parameters;
  
  CommandResult({
    required this.type,
    required this.parameters,
  });
}
