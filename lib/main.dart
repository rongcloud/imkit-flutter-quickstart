import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert' show json;

import 'package:flutter/services.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';



void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  static const String privateUserId = "ios";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {

    //融云 appkey
    String RongAppKey = 'pvxdm17jxjaor';
    //用户 id
    String userId = 'android';
    //通过用户 id 生成的对应融云 token
    String RongIMToken = '/GAO1QE3NeKdxZ8EFWZnXSBpWcymqs7mr0LfCBn63cWXAWvMuW73BKKASyaZmGFGhVYuRiYRxSacloyurITSuw==';

    //1.初始化 im SDK
    RongcloudImPlugin.init(RongAppKey);

    //2.配置 im SDK
    String confString = await DefaultAssetBundle.of(context).loadString("assets/RCFlutterConf.json");
    Map confMap = json.decode(confString.toString());
    RongcloudImPlugin.config(confMap);

    //3.连接 im SDK
    int rc = await RongcloudImPlugin.connect(RongIMToken);
    print('connect result');
    print(rc);

    //4.刷新当前用户的用户信息
    String portraitUrl = "https://www.rongcloud.cn/pc/images/huawei-icon.png";
    RongcloudImPlugin.updateCurrentUserInfo(userId, "李四", portraitUrl);

    //5.设置监听回调，处理 native 层传递过来的事件
    _addIMHander();

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    setState(() {

    });
  }

  _addIMHander() {
    //收到消息原生会触发此方法
    RongcloudImPlugin.onMessageReceived = (Message msg, int left) {
      //会话类型，单聊/群聊/聊天室
      print("conversationType = "+msg.conversationType.toString());
      print("targetId = "+msg.targetId);
      print("senderUserId="+msg.senderUserId);
    };

    //发送消息会触发此回调，通知 flutter 层消息发送结果
    RongcloudImPlugin.onMessageSend = (int messageId, int status, int code) {
      // {"messageId":12,"status":30}
      // messageId 为本地数据库自增字段
      // status 结果参见 RCMessageSentStatus 的枚举值
      print("message sent "+ messageId.toString());
    };

    //上传图片进度的回调
    RongcloudImPlugin.onUploadMediaProgress = (int messageId, int progress) {
      //{"messageId",messageId,"progress",99}
      print("upload image message progress = "+progress.toString());
    };

    //加入聊天室的回调
    RongcloudImPlugin.onJoinChatRoom = (String targetId, int status) {
      //targetId 聊天室 id
      //status 参见 RCOperationStatus
      print("join chatroom result ="+status.toString());
    };

    //退出聊天室的回调
    RongcloudImPlugin.onQuitChatRoom = (String targetId, int status) {
      //targetId 聊天室 id
      //status 参见 RCOperationStatus
      print("quit chatroom result ="+status.toString());
    };
  }

  onSendMessage() async{
      TextMessage txtMessage = new TextMessage();
      txtMessage.content = "这条消息来自 flutter";
      Message msg = await RongcloudImPlugin.sendMessage(RCConversationType.Private, privateUserId, txtMessage);
      print("send message start senderUserId = "+msg.senderUserId);
  }

  onSendImageMessage() async {
    ImageMessage imgMessage = new ImageMessage();
    imgMessage.localPath = "image/local/path.jpg";
    Message msg = await RongcloudImPlugin.sendMessage(RCConversationType.Private, privateUserId, imgMessage);
    print("send image message start senderUserId = "+msg.senderUserId);
  }

  onGetHistoryMessages() async {
    List msgs = await RongcloudImPlugin.getHistoryMessage(RCConversationType.Private, privateUserId, 0, 10);
    print("get history message");
    for(Message m in msgs) {
      print("sentTime = "+m.sentTime.toString());
    }
  }

  onGetConversationList() async {
    List cons = await RongcloudImPlugin.getConversationList([RCConversationType.Private,RCConversationType.Group]);
    for(Conversation con in cons) {
      print("conversation latestMessageId " + con.latestMessageId.toString());
    }
  }

  onJoinChatRoom() {
    RongcloudImPlugin.joinChatRoom("testchatroomId", 10);
  }

  onQuitChatRoom() {
    RongcloudImPlugin.quitChatRoom("testchatroomId");
  }

  onGetChatRoomInfo() async {
    ChatRoomInfo chatRoomInfo = await RongcloudImPlugin.getChatRoomInfo("testchatroomId", 10, RCChatRoomMemberOrder.Desc);
    print("onGetChatRoomInfo targetId ="+chatRoomInfo.targetId);
  }

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: IndexPage(),
    // );
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 500,
              child: Column(
                children: <Widget>[
                  Row(children: <Widget>[]),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              onPressed: () => onSendMessage(),
                              child: Text("sendMessage"),
                              color: Colors.blueAccent,
                              textColor: Colors.white,
                            ),
                          )
                        ],
                        
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              onPressed: () => onGetHistoryMessages(),
                              child: Text("onGetHistoryMessages"),
                              color: Colors.blueAccent,
                              textColor: Colors.white,
                            ),
                          )
                        ],
                        
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              onPressed: () => onGetConversationList(),
                              child: Text("onGetConversationList"),
                              color: Colors.blueAccent,
                              textColor: Colors.white,
                            ),
                          )
                        ],
                        
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              onPressed: () => onJoinChatRoom(),
                              child: Text("onJoinChatRoom"),
                              color: Colors.blueAccent,
                              textColor: Colors.white,
                            ),
                          )
                        ],
                        
                      )
                    ),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              onPressed: () => onGetChatRoomInfo(),
                              child: Text("onGetChatRoomInfo"),
                              color: Colors.blueAccent,
                              textColor: Colors.white,
                            ),
                          )
                        ],
                        
                      )
                    )
                ],
              )
              ),
        ),
      ),
    );
  }
  
}
