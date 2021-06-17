import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:p_chat/helper/constants.dart';
import 'package:p_chat/helper/helperfunctions.dart';
import 'package:p_chat/services/database.dart';
import 'package:p_chat/widgets/widget.dart';

import 'conversation_screen.dart';
class SearchScreen extends StatefulWidget {

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();

  QuerySnapshot searchSnapshot;
  Widget searchList(){
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          return SearchTile(
            userName: searchSnapshot.documents[index].data["name"],
            userEmail: searchSnapshot.documents[index].data["email"],
          );
        }
    ):Container();
  }

  initiateSearch(){
    databaseMethods.
    getUserByUserName(searchTextEditingController.text).
    then((val){
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  ///create charoom, send user to conversation screen,pushreplacement
  createChatRoomAndStartConversation({String userName}){
    if(userName != Constants.myName){
      String chatRoomId = getChatRoomId(userName ,Constants.myName);

      List<String> users= [userName ,Constants.myName];
      Map<String ,dynamic>chatRoomMap = {
        "users":users,
        "chatroomid": chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId,chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context)=> ConversationScreen(
            chatRoomId,
          )
      ));
      print("${chatRoomId + Constants.myName +userName}");
    }else{
      print("you cannot send message to yourself");
    }
  }
  Widget SearchTile({String userName, String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style:  highTextFieldStyle(),),
              Text(userEmail, style:  highTextFieldStyle(),),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatRoomAndStartConversation(
                userName: userName,
              );
            },
            child: Container(
              decoration:  BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("Messenge",style:highTextFieldStyle()),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      style: TextStyle(
                      color: Colors.white,fontSize: 25
                    ),
                      decoration: InputDecoration(
                        hintText: "search username...",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        border: InputBorder.none
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0x36FFFFFF),
                              const Color(0x0FFFFFFF),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(40)
                        ),
                        padding: EdgeInsets.all(8),
                        child: Image.asset("assets/images/search_white.png")),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}
getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}