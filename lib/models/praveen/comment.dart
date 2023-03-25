import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String comment;
  String? itemId;
  String? userId;
  Timestamp? createdAt;
  String? uid;

  //Receiving Data
  CommentModel(
      {required this.comment,
      this.itemId,
      this.userId,
      this.createdAt,
      this.uid});

  factory CommentModel.fromMap(map) {
    return CommentModel(
        comment: map['comment'],
        itemId: map['itemId'],
        userId: map['userId'],
        createdAt: map['createdAt'],
        uid: map['uid']);
  }

  //Sending Data
  Map<String, dynamic> toMap() {
    return {
      'comment': comment,
      'itemId': itemId,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
      'uid': uid
    };
  }
}
