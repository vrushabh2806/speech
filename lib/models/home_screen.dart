import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow Voice Todo'),
      ),
      body: const Center(
        child: Text('Your voice-driven todo list'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Voice command capture will go here
        },
        tooltip: 'Voice Command',
        child: const Icon(Icons.mic),
      ),
    );
  }
}
