import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/User.dart';

class UsersDao {

  static CollectionReference<User> getUsersCollection(){
    var db = FirebaseFirestore.instance;
    var usersCollection = db.collection(User.collectionName)
        .withConverter(fromFirestore:
        (snapshot, options) => User.fromFireStore(snapshot.data())
      , toFirestore: (Object, options) => Object.toFireStore(),);
    return usersCollection;
  }

  static Future <void> createUser(User user){
    var usercollection = getUsersCollection();
    usercollection.add(user);
    var doc = usercollection.doc(user.id);
    return doc.set(user);
  }

  static Future <User?> getUser(String? uid) async {
    var doc = getUsersCollection().doc(uid);
    var docSnapshot = await doc.get();

    return docSnapshot.data();
  }
}