import 'package:flutter/material.dart';

import 'comment_box.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({
    super.key,
    required this.imgURL,
    required this.onLiked,
    required this.onDisliked,
    required this.onCommentTap,
    required this.onGotoCommentList,
    this.comment1,
    this.comment2,
    required this.commentCount,
  });

  final String imgURL;
  final GestureTapCallback onLiked;
  final GestureTapCallback onDisliked;
  final GestureTapCallback onCommentTap;
  final GestureTapCallback onGotoCommentList;
  final Widget? comment1;
  final Widget? comment2;
  final String commentCount;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.asset(
            widget.imgURL,
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
        Row(
          children: [
            IconButton(
                onPressed: widget.onLiked,
                icon: const Icon(Icons.thumb_up_sharp)),
            IconButton(
                onPressed: widget.onDisliked,
                icon: const Icon(Icons.thumb_down_sharp)),
            const Spacer(),
            IconButton(
                onPressed: widget.onCommentTap,
                icon: const Icon(Icons.comment)),
            Text(
              widget.commentCount,
            )
          ],
        ),
        const SizedBox(
          height: 15.0,
        ),
        GestureDetector(
          onTap: widget.onGotoCommentList,
          child: Column(
            children: [
              widget.comment1 ?? const SizedBox(),
              // CommentBox(
              //   image: 'assets/praveen/img1.jpg',
              //   comment: 'Lorem ipsum dolar amet....',
              // ),

              if (widget.comment2 != null) ...[
                const SizedBox(
                  height: 10.0,
                ),
              ],

              widget.comment2 ?? const SizedBox(),
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
