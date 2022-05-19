import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Google_login_widget extends StatefulWidget {
  bool loggedin = false;

  @override
  State<Google_login_widget> createState() => _Google_login_widgetState();
}

class _Google_login_widgetState extends State<Google_login_widget> {

  final GoogleSignIn _googleSignIn =GoogleSignIn(
scopes: [
  'email'
]
  );

  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
    super.initState();
  }

  void signOut(){
    _googleSignIn.disconnect();
  }
  Future<void> signIn() async{
    try{
      await _googleSignIn.signIn();
    }catch(e){
      print('the error is $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? user= _currentUser;
    if (user!=null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Google signIn'),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 20),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  ListTile(
                    leading:GoogleUserCircleAvatar(identity: user,),
                    title:  Text(user.displayName!),
                    subtitle: Text(user.email),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'signedin succesfully',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(onPressed: signOut, child: Text('signout')),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Google signIn'),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 20),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'you are not signed in',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: signIn,
                    child: Text('sign in'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
