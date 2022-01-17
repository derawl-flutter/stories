import 'package:flutter/material.dart';


class StoryBook extends StatelessWidget {
  const StoryBook({
    Key? key,
    required this.bookImage,
    required this.pressed
  }) : super(key: key);

  final String bookImage;
  final VoidCallback pressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: pressed,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        width: 120,
        height: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueGrey,
            image: DecorationImage(
                image: NetworkImage(bookImage),
                fit: BoxFit.cover
            )
        ),
      ),
    );
  }
}