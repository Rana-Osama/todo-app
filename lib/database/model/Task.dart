import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String? id;
  String? title;
  String? description;
  bool isDone;
  Timestamp? dateTime;

  static const String collectionName = 'tasks';

  Task(
      {this.id,
      this.title,
      this.description,
      this.isDone = false,
      this.dateTime});

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
      'dateTime': dateTime
    };
  }

  Task.fromFireStore(Map<String, dynamic>? data)
      : this(
            id: data?['id'],
            title: data?['title'],
            description: data?['description'],
            dateTime: data?['dateTime'],
            isDone: data?['isDone']);
}
