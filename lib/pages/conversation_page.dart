
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ConversationPageState();
  }
}

class _ConversationPageState extends State<ConversationPage> {
  int conversationType ;
  String targetId ;
  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    conversationType = arg["coversationType"];
    targetId = arg["targetId"];
    print("push to conversation page: conversationType "+ conversationType.toString() + "  targetId "+targetId);
    return new Scaffold(
      appBar: AppBar(
        title: Text("RongCloud IM"),
      ),
      body: Text("data"),
    );
  }
  
}