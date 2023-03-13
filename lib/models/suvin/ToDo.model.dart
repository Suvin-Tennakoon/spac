import 'package:cloud_firestore/cloud_firestore.dart';

class ToDo {
  String taskname;
  bool completeness;

  ToDo(this.taskname, this.completeness);

  Map<String, dynamic> toMap() {
    return {'taskname': taskname, 'completeness': completeness};
  }

  factory ToDo.fromMap(DocumentSnapshot data) {
    return ToDo(data['taskname'], data['completeness']);
  }
}
