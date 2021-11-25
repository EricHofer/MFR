// ignore_for_file: import_of_legacy_library_into_null_safe
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mfr/home.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mfr/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // final keyApplicationId = 'dZvOVUVPIpNGy7cLObYhcxXDoYjj97iE8H0V9QtX';
  final keyApplicationId = 'DFPBEvupqVSQAGJLX3ah4TrEJNEHWJqfDOt6lmMf';
  // final keyClientKey = '41gzATq0wpMcRsm0esk4MR3itmv4aUnwv8VV46H3';
  final keyClientKey = 'SeJQ9dXRbRa6MUR0Z4Xedr1wulYNg3nfph1BXNUk';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true, debug: true);
  var firstObject = ParseObject('FirstClass')..set('message', 'Hey ! First message from Flutter. Parse is now connected');
  // await firstObject.save();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly']);
  
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  ParseUser _parseUser = ParseUser("", "", "");


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MFR App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
            Padding(padding: EdgeInsets.only(top: 20),),
            Container(
              width: 300,
              child: RaisedButton(
                padding: const EdgeInsets.all(20),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  emailLogin(usernameController.text, passController.text, emailController.text);
                },
                child: Text('Login'),
              ),
              
            ),
            Padding(padding: EdgeInsets.only(top: 20),),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> new RegisterScreen()));
              },
              child: Text("Don't you have account?", style:TextStyle(color: Colors.black, decoration: TextDecoration.underline)),
            ),
            Padding(padding: EdgeInsets.only(top: 20),),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Divider(
                color: Colors.black,
                height: 2,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              width: 300,
              child: RaisedButton(
                padding: const EdgeInsets.all(20),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  _facebooksignIn().then((value) {
                    if(value != ""){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Home()));
                    }
                  });
                },
                child: Text('Login by Facebook'),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              width: 300,
              child: RaisedButton(
                padding: const EdgeInsets.all(20),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  googleSignIn();
                },
                child: Text('Login by Google'),
              )
            ),
          ],
        ),
      ),
       
    );
  }

  Future<String> _facebooksignIn() async {
    User? user;
    String a = "";
    final FacebookLogin facebookLogin = FacebookLogin();
    FacebookLoginResult loginResult = await facebookLogin.logInWithReadPermissions(['email']);
    if (loginResult.status == FacebookLoginStatus.loggedIn) {
      // final AuthCredential credential = FacebookAuthProvider.credential(loginResult.accessToken.token,);
      // final UserCredential authResult = await _auth.signInWithCredential(credential);
      // user = authResult.user;
      final ParseResponse response = await ParseUser.loginWith('facebook', facebook(loginResult.accessToken.token, loginResult.accessToken.userId, loginResult.accessToken.expires));
      if(response.success){
        a = loginResult.accessToken.userId;
      }
    }
    // return user!.uid;
    return a;
  }

  googleSignIn() async {
    
    GoogleSignInAccount? account = await _googleSignIn.signIn();
    if(account != null){
      print("------------account:${account.id}");
      GoogleSignInAuthentication authentication = await account.authentication;
      final ParseResponse response = await ParseUser.loginWith('google', 
        google(
            authentication.accessToken.toString(),
            account.id,
            authentication.idToken.toString(), 
          )
        );
      if (response.success) {
        print('parse google signin successs');
        print(account.email);
         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Home()));
      } else {
        print('parse google SignIn Failed');
        print('response.error:  ' + response.error.toString());
        // print(google(_googleSignIn.currentUser.id,
        //     authentication.accessToken.toString(), authentication.idToken));
      }
    }
    else{
      print("-----failed------");
    }
  }

  Future<ParseUser> emailLogin(username, pass, email) async {
    var user = ParseUser(username, pass, email);
    var response = await user.login();
    if (response.success) {
      setState(() {
        _parseUser = user; //Keep the user
      });
      print(user.objectId);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Home(parseUser: user,)));
    } else {
      print(response.error?.message);
    }
    return user;
  }
}
