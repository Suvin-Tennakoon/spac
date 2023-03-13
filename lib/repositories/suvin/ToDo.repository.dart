import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spac/models/suvin/ToDo.model.dart';

class ToDoRepository {
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('todos');

  Stream<List<ToDo>> todos() {
    return _collectionReference.orderBy('taskname').snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => ToDo.fromMap(doc)).toList());
  }

  Future<void> addToDo(ToDo toDo) {
    return _collectionReference.add((toDo.toMap()));
  }

  Future<void> updateToDo(String id, ToDo toDo) {
    return _collectionReference.doc(id).update((toDo.toMap()));
  }

  Future<void> deleteToDo(String id) {
    return _collectionReference.doc(id).delete();
  }
}
