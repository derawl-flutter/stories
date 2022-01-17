import 'package:flutter/material.dart';
import 'package:card_loading/card_loading.dart';

class BookLoading extends StatelessWidget {
  const BookLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Center(child: Container(
        height: 170,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            CardLoading(height: 170, width: 110, borderRadius: 15, margin: EdgeInsets.all(10),),
            CardLoading(height: 170, width: 120, borderRadius: 15, margin: EdgeInsets.all(10),),
            CardLoading(height: 170, width: 120, borderRadius: 15, margin: EdgeInsets.all(10),),

          ],
        ),
      )),
    );
  }
}
