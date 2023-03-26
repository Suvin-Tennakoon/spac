import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:spac/models/praveen/comment.dart';
import 'package:spac/repositories/praveen/CommentRepository.dart';
import 'package:spac/screens/praveen/comment_list_screen/comment_list_screen.dart';

import '../components/comment_box.dart';
import '../components/item_card.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bidding Items',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (context, index) {
              return const Divider(
                height: 50.0,
              );
            },
            itemCount: 5,
            itemBuilder: (context, index) {
              String imageURL = 'assets/praveen/item${index + 1}.jpg';
              print(imageURL);

              CommentModel commentModel1 = _comments[0];
              CommentModel commentModel2 = _comments[1];

              int commentCount = _comments.length;

              return ItemCard(
                onGotoCommentList: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CommentList()));
                },
                imgURL: imageURL,
                onLiked: () {},
                onCommentTap: () {},
                onDisliked: () {},
                comment1: CommentBox(
                  uid: commentModel1.uid,
                  image: 'assets/praveen/img2.jpg',
                  comment: commentModel1.comment,
                ),
                comment2: CommentBox(
                  uid: commentModel2.uid,
                  image: 'assets/praveen/img3.jpg',
                  comment: commentModel2.comment,
                ),
                commentCount: commentCount.toString(),
              );
            }),
      ),
    );
  }
}
