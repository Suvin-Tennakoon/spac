import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:spac/models/praveen/comment.dart';
import 'package:spac/repositories/praveen/CommentRepository.dart';
import 'package:spac/screens/praveen/components/comment_box.dart';

class CommentList extends StatefulWidget {
  const CommentList({super.key});

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  List<CommentModel> _comments = [];
  final CommentRepository _auth = CommentRepository();
  late String _comment = "";

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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Comments',
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        height: size.height,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _comments.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 5.0,
                    );
                  },
                  itemBuilder: (context, index) {
                    CommentModel commentModel = _comments[index];

                    return CommentBox(
                      uid: commentModel.uid,
                      image: 'assets/praveen/img1.jpg',
                      comment: commentModel.comment,
                      isOwnComment: index % 2 == 0,
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'Enter your comment...',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _comment = value;
                  });
                },
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: () {
                      CommentModel comment =
                          CommentModel(comment: _comment, uid: "");
                      CommentRepository commentRepository = CommentRepository();
                      commentRepository.addComment(comment);
                      _fetchComments();
                    },
                    child: const Text('Add Comment')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
