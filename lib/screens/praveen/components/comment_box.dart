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
            IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
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
