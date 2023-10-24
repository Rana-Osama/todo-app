import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/database/UsersDao.dart';
import 'package:todo_app/database/model/Task.dart';

class TasksDao {

  static CollectionReference<Task>getTasksCollection(String uid){
   var tasksCollection = UsersDao.getUsersCollection().doc(uid).collection(Task.collectionName)
    .withConverter(fromFirestore:
        (snapshot, options) => Task.fromFireStore(snapshot.data())
      , toFirestore: (task, options) => task.toFirestore(),);

   return tasksCollection;
  }

   static  Future <void> createTask (Task task , String  uid ){
    var docReference = getTasksCollection(uid).doc();
    task.id = docReference.id ;

    return docReference.set(task);
  }


  static Future<List<Task>> getAllTasks (String uid) async {
    //read data once
    var tasksSnapshot = await getTasksCollection(uid).get();
    var tasksList = tasksSnapshot.docs.map((snapshot) => snapshot.data()).toList();
    return tasksList;
  }

  static Stream<List<Task>>listenForTasks (String uid , DateTime selectedDay) async*{
    var dateOnly = selectedDay.copyWith(hour: 0,minute: 0,second: 0,microsecond: 0,millisecond: 0);
    var stream =  getTasksCollection(uid).where('dateTime',
        isEqualTo: Timestamp.fromMillisecondsSinceEpoch(
            dateOnly.millisecondsSinceEpoch)).snapshots();
    //convert for stream then convert stream to task
   yield* stream.map((querySnapshot) => querySnapshot.docs.map((doc) =>
        doc.data()).toList());

  }

  static Future<void> removeTask(String taskId, String uid) {
    return getTasksCollection(uid).doc(taskId).delete();
  }

  static Future<void> editTask (Task task, String uid) async {
   await getTasksCollection(uid).doc(task.id).update(task.toFirestore());
  }
}
