
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';
import 'item/conversation_list_item.dart';

class ConversationListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ConversationListPageState();
  }
}

class _ConversationListPageState extends State<ConversationListPage> {

  List conList = new List();

  @override
  void initState() {
    super.initState();
    addIMhandler();
    updateConversationList();
  }

  updateConversationList() async {
    List list = await RongcloudImPlugin.getConversationList([RCConversationType.Private,RCConversationType.Group]);
    list.sort((a,b) => b.sentTime.compareTo(a.sentTime));
    setState(() {
      conList = list;
    });
  }

  addIMhandler() {
    RongcloudImPlugin.onMessageReceived = (Message msg, int left) {
      if(left == 0) {
        updateConversationList();
      }
    };

    RongcloudImPlugin.onConnectionStatusChange = (int connectionStatus) {
      if(RCConnectionStatus.Connected == connectionStatus) {
        updateConversationList();
      }
    };
  }

  ListView _buildConversationListView() {
    return new ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: conList.length,
      itemBuilder: (BuildContext context,int index) {
        if(conList.length <= 0) {
          return null;
        }
        return ConversationListItem(conversation:conList[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: UniqueKey(),
      body: _buildConversationListView(),
    );
  }
  
}