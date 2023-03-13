import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spac/models/suvin/ToDo.model.dart';
import 'package:spac/repositories/suvin/ToDo.repository.dart';

class AddToDo extends StatefulWidget {
  const AddToDo({super.key});

  @override
  State<AddToDo> createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  final _formKey = GlobalKey<FormState>();
  late String _todo;

  @override
  void initState() {
    super.initState();
    _todo = '';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Row(
            children: [
              const Padding(padding: EdgeInsets.all(10.0)),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.task_outlined),
                    hintText: 'Enter a ToDo',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _todo = value;
                    });
                  },
                ),
              ),
              IconButton(
                  onPressed: () {
                    ToDo toDo = ToDo(_todo, false);
                    ToDoRepository toDoRepository = ToDoRepository();
                    toDoRepository.addToDo(toDo);

                    setState(() {});
                  },
                  icon: const Icon(Icons.add)),
              const Padding(padding: EdgeInsets.all(10.0)),
            ],
          ),
          StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('todos').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                return Material(
                  child: ListView(
                      shrinkWrap: true,
                      children: snapshot.data!.docs.map((doc) {
                        return Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                  title: Text(doc['taskname'],
                                      style: doc['completeness'] == true
                                          ? const TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Color.fromARGB(
                                                  255, 168, 165, 155))
                                          : const TextStyle(
                                              decoration: TextDecoration.none,
                                              color: Color.fromARGB(
                                                  255, 255, 44, 7))),
                                  value: doc['completeness'],
                                  onChanged: (selected) {
                                    if (selected == true) {
                                      ToDo toDo = ToDo(doc['taskname'], true);
                                      ToDoRepository repository =
                                          ToDoRepository();
                                      repository.updateToDo(doc.id, toDo);
                                    } else {
                                      ToDo toDo = ToDo(doc['taskname'], false);
                                      ToDoRepository repository =
                                          ToDoRepository();
                                      repository.updateToDo(doc.id, toDo);
                                    }

                                    setState(() {});
                                  }),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  ToDoRepository repository = ToDoRepository();
                                  repository.deleteToDo(doc.id);
                                },
                                child: const Icon(Icons.delete))
                          ],
                        );
                      }).toList()),
                );
              }),
        ],
      ),
    );
  }
}
