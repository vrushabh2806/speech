import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudSyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Collection reference
  CollectionReference get _tasksCollection {
    final user = _auth.currentUser;
    if (user == null) {
      // Return a dummy collection if no user is logged in
      return _firestore.collection('dummy_tasks');
    }
    return _firestore.collection('users/${user.uid}/tasks');
  }

  // Get a stream of tasks from Firestore
  Stream<List<Task>> tasksStream() {
    final user = _auth.currentUser;
    if (user == null) {
      // Return empty stream if no user is logged in
      return Stream.value([]);
    }

    return _tasksCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Task.fromMap({
          'id': doc.id,
          ...data,
        });
      }).toList();
    });
  }

  // Add a new task to Firestore
  Future<void> addTask(Task task) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _tasksCollection.doc(task.id).set(task.toMap());
  }

  // Update an existing task
  Future<void> updateTask(Task task) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _tasksCollection.doc(task.id).update(task.toMap());
  }

  // Delete a task
  Future<void> deleteTask(String id) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _tasksCollection.doc(id).delete();
  }

  // Optional: User authentication helpers
  Future<bool> isUserLoggedIn() async {
    return _auth.currentUser != null;
  }

  Future<void> signInAnonymously() async {
    await _auth.signInAnonymously();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

// Task model
class Task {
  final String id;
  final String title;
  final bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.isDone,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'] ?? '',
      isDone: map['isDone'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isDone': isDone,
    };
  }
}
