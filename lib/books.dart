import 'package:flutter/material.dart';


class Page extends StatelessWidget {
  const Page({Key? key, required this.lines}) : super(key: key);

  final lines;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(lines.toString()),
    );
  }
}
