import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:spac/screens/praveen/components/comment_box.dart';

class CommentList extends StatelessWidget {
  const CommentList({super.key});

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
                  itemCount: 10,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 5.0,
                    );
                  },
                  itemBuilder: (context, index) {
                    return CommentBox(
                      image: 'assets/praveen/img1.jpg',
                      comment: "This is comment ${index + 1}",
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
                obscureText: true,
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
              ),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {},
                  child: const Text('Add Comment')
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}