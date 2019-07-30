import 'package:flutter/material.dart';

class BottomInputBar extends StatefulWidget {
  @override
  _BottomInputBarState createState() => _BottomInputBarState();
}

class _BottomInputBarState extends State<BottomInputBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      height: 90,
      padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
      child: TextField(

      )
    );
  }
}