import 'package:flutter/material.dart';
import 'package:spac/models/praveen/comment.dart';
import 'package:spac/repositories/praveen/CommentRepository.dart';
import 'package:spac/screens/praveen/comment_list_screen/comment_list_screen.dart';

class CommentBox extends StatefulWidget {
  const CommentBox({
    Key? key,
    required this.uid,
    required this.image,
    required this.comment,
    this.isOwnComment = false,
  }) : super(key: key);

  final String uid;
  final String image;
  final String comment;
  final bool isOwnComment;

  @override
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  List<CommentModel> _comments = [];
  final TextEditingController _commentController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    isLoading = true;

    setState(() {
      isLoading = false;
    });

    super.initState();
    _fetchComments();
  }

  void _fetchComments() async {
    List<CommentModel> comments = await CommentRepository().comments();
    setState(() {
      _comments = comments;
    });
  }

  void _update(CommentModel commentModel) async {
    _commentController.text = commentModel.comment;
    String uid = commentModel.uid;

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(labelText: 'Comment'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    LoadingDialog.show(context);

                    commentModel.comment = _commentController.text;
                    CommentRepository commentRepository = CommentRepository();

                    print(commentModel.comment);

                    dynamic result =
                        await commentRepository.updateComment(commentModel);

                    print(result);
                    if (result == 'Success') {
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CommentList()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(bottom: 100.0),
                        content: new Text("Comment Updated"),
                        dismissDirection: DismissDirection.none,
                        backgroundColor: Color.fromARGB(255, 22, 8, 222),
                      ));
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                      print('Error');
                    }

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => CommentList()),
                    // );
                  },
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            child: Image.asset(
              widget.image,
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            widget.comment,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
          const Spacer(),
          if (widget.isOwnComment) ...[
            IconButton(
                onPressed: () {
                  print(widget.uid);
                  print(widget.comment);
                  CommentModel commentModel =
                      CommentModel(comment: widget.comment, uid: widget.uid);

                  _update(commentModel);
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                // onPressed: () {
                // print(widget.uid);
                // print(widget.comment);
                // CommentModel commentModel =
                //     CommentModel(comment: widget.comment, uid: widget.uid);
                // CommentRepository commentRepository = CommentRepository();
                // commentRepository.deleteComment(commentModel);

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => CommentList()),
                // );
                // },
                onPressed: () async {
                  print(widget.uid);
                  print(widget.comment);
                  CommentModel commentModel =
                      CommentModel(comment: widget.comment, uid: widget.uid);
                  CommentRepository commentRepository = CommentRepository();

                  showDialog<String>(
                    context: context,
                    builder: (BuildContext contextF) => AlertDialog(
                      title: const Text('Delete Comment'),
                      content: const Text(
                          "Are you sure that you want to permanently remove this comment ?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(contextF, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            LoadingDialog.show(context);
                            setState(() {
                              isLoading = true;
                            });
                            Navigator.pop(contextF, 'Yes');
                            dynamic result = await commentRepository
                                .deleteComment(commentModel);
                            ;
                            print(result);
                            if (result == 'Success') {
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CommentList()),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.only(bottom: 100.0),
                                content: new Text("Comment Deleted"),
                                dismissDirection: DismissDirection.none,
                                backgroundColor:
                                    Color.fromARGB(255, 235, 136, 129),
                              ));
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              print('Error');
                            }
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                )),
          ]
        ],
      ),
    );
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 150,
            height: 130,
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Column(
                children: const [
                  CircularProgressIndicator(
                    color: Colors.green,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    "Working on your action...",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 34, 57, 139)),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
