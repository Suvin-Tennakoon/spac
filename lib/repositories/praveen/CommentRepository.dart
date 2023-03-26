import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spac/models/praveen/comment.dart';
import 'package:uuid/uuid.dart';

class CommentRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  var uuid = Uuid();
  late final String _uid;

  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('comments');
  // Stream<List<CommentModel>> comments() {
  //   return _collection.orderBy('createdAt').snapshots().map((snapshot) =>
  //       snapshot.docs.map((doc) => CommentModel.fromMap(doc)).toList());
  // }

  Future<List<CommentModel>> comments() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _fireStore.collection('comments').orderBy('createdAt').get();

      List<CommentModel> comments = [];
      querySnapshot.docs.forEach((doc) {
        CommentModel comment = CommentModel.fromMap(doc.data());
        comments.add(comment);
      });

      return comments;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future addComment(CommentModel comment) async {
    comment.uid = uuid.v1();
    comment.itemId = "item1";
    comment.userId = "user3";
    try {
      await _collection.doc(comment.uid).set(comment.toMap());

      return 'Success';
    } on FirebaseAuthException catch (e) {
      print(e);
      return null;
    }

    // return _collection.add(comment.toMap());
  }

  Future updateComment(CommentModel comment) async {
    try {
      await _collection.doc(comment.uid).update(comment.toMap());

      return 'Success';
    } on FirebaseAuthException catch (e) {
      print(e);
      return null;
    }
  }

  Future deleteComment(CommentModel comment) async {
    try {
      await _collection.doc(comment.uid).delete();

      return 'Success';
    } on FirebaseAuthException catch (e) {
      print(e);
      return null;
    }
  }
}
