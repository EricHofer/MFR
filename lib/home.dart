
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:mfr/main.dart';

class Home extends StatefulWidget {

  var parseUser;
  
  Home({
    Key? key,
    this.parseUser,
  }) : super(key: key);
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  late ParseUser currentUser;

  @override
  void initState() {
    super.initState();
    if(widget.parseUser == null){
      _Userload();
    }
    else{
      currentUser = widget.parseUser;
    }
     
  }

  void _Userload() async {
    currentUser = await ParseUser.currentUser(); //The current user was save in the phone with SharedPrefferences
    if (currentUser == null) {
      return null;
    } else {
      
      print("AUTO LOGIN SUCCESS");
      // print("-------------user_info:${currentUser}");
      // var result = currentUser.login();
      // result.catchError((e) {
      //   print(e);
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[ 
            Text('Login Success!', style: TextStyle(color: Colors.black),),
            Padding(padding: EdgeInsets.only(top: 40),),
            Container(
              width: 300,
              child: RaisedButton(
                padding: const EdgeInsets.all(20),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () async {
                  // var user = widget.parseUser;
                  var response = await currentUser.logout();
                  if(response.success){
                    widget.parseUser = null;
                    print("LOGOFF SUCCESS");
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
                  } else{
                    print(response.error?.message);
                  }
                },
                child: Text('LogOut'),
              ),
              
            ),
          ]
        )
      ),
    );
  }
  
}