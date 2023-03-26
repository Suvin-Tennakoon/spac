import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:spac/models/praveen/comment.dart';
import 'package:spac/repositories/praveen/CommentRepository.dart';
import 'package:spac/screens/praveen/components/comment_box.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CommentList extends StatefulWidget {
  const CommentList({
    super.key,
    this.updateCommentWidget,
  });

  final Widget? updateCommentWidget;

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
                    String profileImg = 'assets/praveen/img${index + 1}.jpg';

                    return CommentBox(
                      uid: commentModel.uid,
                      image: profileImg,
                      comment: commentModel.comment,
                      isOwnComment: index % 3 == 0,
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
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 50.0,
                width: double.infinity,
                child: FilledButton(
                    onPressed: () async {
                      LoadingDialog.show(context);
                      CommentModel comment =
                          CommentModel(comment: _comment, uid: "");
                      CommentRepository commentRepository = CommentRepository();
                      dynamic result =
                          await commentRepository.addComment(comment);

                      if (result == 'Success') {
                        // _fetchComments();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CommentList()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(bottom: 100.0),
                          content: new Text("New comment added"),
                          dismissDirection: DismissDirection.none,
                          backgroundColor: Color.fromARGB(255, 86, 103, 233),
                        ));
                      } else {
                        print('Error');
                      }
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
