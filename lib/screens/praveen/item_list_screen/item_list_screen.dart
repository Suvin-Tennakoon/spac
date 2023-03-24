import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:spac/screens/praveen/comment_list_screen/comment_list_screen.dart';

import '../components/comment_box.dart';
import '../components/item_card.dart';

class ItemListScreen extends StatelessWidget {
  const ItemListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Items',
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
            return ItemCard(
              onGotoCommentList: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CommentList()));
              },
              onLiked: () {},
              onCommentTap: () {},
              onDisliked: () {},
              comment1: const CommentBox(
                image: 'assets/praveen/img1.jpg',
                comment: 'Lorem ipsum dolar amet....',
              ),
              comment2: const CommentBox(
                image: 'assets/praveen/img1.jpg',
                comment: 'Lorem ipsum dolar amet....',
              ),
            );
          }
        ),
      ),
    );
  }
}
