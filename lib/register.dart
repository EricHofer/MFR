
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:mfr/home.dart';

class RegisterScreen extends StatefulWidget {

  @override
  RegisterScreenState createState()=> RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  ParseUser _parseUser = ParseUser("", "", "");
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                    hintText: 'Username'
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              child:TextField(
                controller: emailController,
                decoration: InputDecoration(
                    hintText: 'E-mail'
                ),
              )
            ),
            Container(
              padding: EdgeInsets.only(left:30, right:30),
              child: TextField(
                controller: passController,
                decoration: InputDecoration(
                    hintText: 'Pass'
                ),
              )
            ),
            Padding(padding: EdgeInsets.only(top: 40),),
            Container(
              width: 300,
              child: RaisedButton(
                padding: const EdgeInsets.all(20),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  emailSignUP(usernameController.text, passController.text,emailController.text);
                },
                child: Text('Sign Up'),
              ),
              
            ),
          ],
        ),
      ),
    );
  }

  Future<ParseUser> emailSignUP(username, pass, email) async {
    var user = ParseUser(username, pass,
        email); 
    var result = await user.create();
    if (result.success) {
      setState(() {
        _parseUser = user;
        print("-----user_info:${_parseUser.username}");
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Home(parseUser: user,)));
        
      });
      print(user.objectId);
    } else {
      print(result.error?.message);
    }
    return user;
  }
}