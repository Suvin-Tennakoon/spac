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

  @override
  void initState() {
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
                    commentModel.comment = _commentController.text;
                    CommentRepository commentRepository = CommentRepository();

                    print(commentModel.comment);
                    commentRepository.updateComment(commentModel);

                    Navigator.of(context).pop();
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
                  print('first update point');
                  print(widget.uid);
                  print(widget.comment);
                  CommentModel commentModel =
                      CommentModel(comment: widget.comment, uid: widget.uid);

                  _update(commentModel);
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  print(widget.uid);
                  print(widget.comment);
                  CommentModel commentModel =
                      CommentModel(comment: widget.comment, uid: widget.uid);
                  CommentRepository commentRepository = CommentRepository();
                  commentRepository.deleteComment(commentModel);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CommentList()),
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
