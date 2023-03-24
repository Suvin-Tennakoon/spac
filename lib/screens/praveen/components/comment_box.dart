import 'package:flutter/material.dart';

class CommentBox extends StatelessWidget {
  const CommentBox({
    Key? key,
    required this.image,
    required this.comment,
    this.isOwnComment = false,
  }) : super(key: key);

  final String image;
  final String comment;
  final bool isOwnComment;

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
              image,
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(
            width: 10.0,
          ),

          Text(
            comment,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),

          const Spacer(),

          if (isOwnComment) ...[
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit)
            ),

            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete, color: Colors.red,)
            ),
          ]
        ],
      ),
    );
  }
}