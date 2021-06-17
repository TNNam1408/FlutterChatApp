import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context){
  return AppBar(
    title: Image.asset("assets/images/logo.png",
      height: 50,),
  );
}

InputDecoration textFieldInputDecoration (String labeltext,String hintext){
  return InputDecoration(
    labelText: labeltext,
    labelStyle: TextStyle(color: Colors.white),
    
    hintText: hintext,
    hintStyle: TextStyle(color: Colors.white, fontSize: 15),

    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),

    // focusedBorder: UnderlineInputBorder(
    //   borderSide: BorderSide(color: Colors.blue),
    // ),
    // enabledBorder: UnderlineInputBorder(
    //   borderSide: BorderSide(color: Colors.blue),
    // ),
  );
}
TextStyle simpleTextFieldStyle(){
  return TextStyle(
      color: Colors.white,
    fontSize: 16
  );
}
TextStyle mediumTextFieldStyle(){
  return TextStyle(
      color: Colors.white,
      fontSize: 17
  );
}

TextStyle highTextFieldStyle(){
  return TextStyle(
      color: Colors.white,
      fontSize: 20
  );
}