import 'package:flutter/material.dart';

import 'comment_box.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.onLiked,
    required this.onDisliked,
    required this.onCommentTap,
    required this.onGotoCommentList,
    this.comment1,
    this.comment2,
  });

  final GestureTapCallback onLiked;
  final GestureTapCallback onDisliked;
  final GestureTapCallback onCommentTap;
  final GestureTapCallback onGotoCommentList;
  final Widget? comment1;
  final Widget? comment2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.asset(
            'assets/praveen/img1.jpg',
          ),
        ),

        const SizedBox(
          height: 15.0,
        ),

        Row(
          children: [
            IconButton(
              onPressed: onLiked,
              icon: const Icon(Icons.thumb_up_sharp)
            ),

            IconButton(
              onPressed: onDisliked,
              icon: const Icon(Icons.thumb_down_sharp)
            ),

            const Spacer(),

            IconButton(
              onPressed: onCommentTap,
              icon: const Icon(Icons.comment)
            ),

            const Text(
              '10',
            )
          ],
        ),

        const SizedBox(
          height: 15.0,
        ),

        GestureDetector(
          onTap: onGotoCommentList,
          child: Column(
            children: [
              comment1 ?? const SizedBox(),
              // CommentBox(
              //   image: 'assets/praveen/img1.jpg',
              //   comment: 'Lorem ipsum dolar amet....',
              // ),
        
              if (comment2 != null) ...[
                const SizedBox(
                  height: 10.0,
                ),
              ],
        
              comment2 ?? const SizedBox(),
              // CommentBox(
              //   image: 'assets/praveen/img1.jpg',
              //   comment: 'Lorem ipsum dolar amet....',
              // )
            ],
          ),
        )
      ],
    );
  }
}