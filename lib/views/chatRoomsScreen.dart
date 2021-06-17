import 'package:flutter/material.dart';
import 'package:p_chat/helper/authenticate.dart';
import 'package:p_chat/helper/constants.dart';
import 'package:p_chat/helper/helperfunctions.dart';
import 'package:p_chat/services/auth.dart';
import 'package:p_chat/services/database.dart';
import 'package:p_chat/views/search.dart';
import 'package:p_chat/views/signin.dart';
import 'package:p_chat/widgets/widget.dart';

import 'conversation_screen.dart';
class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomStream;

  Widget chatRoomList(){
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot){
          return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index){
              return ChatRoomTile(
                snapshot.data.documents[index].data["chatroomid"]
                    .toString().replaceAll("_", "")
                    .replaceAll(Constants.myName, ""),
                  snapshot.data.documents[index].data["chatroomid"]
              );
              },
          ):Container();
        },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }
  getUserInfo() async{
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRoom(Constants.myName).then((val){
      setState(() {
        chatRoomStream = val;
      });
    });
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/logo.png",
        height: 50,
        ),
        actions: [
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context)=>Authenticate()
              ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14),
                child: Icon(Icons.exit_to_app,size: 30,)),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => SearchScreen()
          ));
        },
      ),
    );
  }
}
class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName, this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId),
        ));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment:  Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text("${userName.substring(0,1).toUpperCase()}",
                style: highTextFieldStyle(),),
            ),
            SizedBox(
              width: 8,
            ),
            Text(userName, style: highTextFieldStyle(),),
          ],
        ),
      ),
    );
  }
}

