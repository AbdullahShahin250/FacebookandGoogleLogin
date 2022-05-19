import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import './google_login_widget.dart';

class Facebook_login_widget extends StatefulWidget {
  bool loggedin = false;

  Facebook_login_widget({required this.loggedin});

  @override
  State<Facebook_login_widget> createState() => _Facebook_login_widgetState();
}

class _Facebook_login_widgetState extends State<Facebook_login_widget> {
  AccessToken? _accessToken;
  UserModel? _currentUser;

  Future<void> signIn() async {
    final LoginResult result = await FacebookAuth.i.login();

    if (result.status == LoginStatus.success) {
      _accessToken = result.accessToken;

      final data = await FacebookAuth.i.getUserData();
      UserModel model = UserModel.fromJson(data);

      _currentUser = model;
      setState(() {});
    }
  }

  Future<void> signOut() async {
    await FacebookAuth.i.logOut();
    _currentUser = null;
    _accessToken = null;
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    UserModel? user = _currentUser;
    if (user != null) {
      return Scaffold(
        body: Container(
          margin: EdgeInsets.only(top: 20),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: user.pictureModel!.width! / 6,
                      backgroundImage: NetworkImage(user.pictureModel!.url!),
                    ),
                    title: Text(user.name!),
                    subtitle: Text(user.email!),
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
        body: Container(
          margin: EdgeInsets.all(20),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'you are not signed in to Facebook',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: signIn,
                    child: Text('sign in'),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    'sign in to google',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Google_login_widget()));
                    },
                    child: Text('sign in to google'),
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

class UserModel {
  final String? email;
  final String? id;
  final String? name;
  final PictureModel? pictureModel;

  const UserModel({this.name, this.pictureModel, this.email, this.id});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      email: json['email'],
      id: json['id'] as String?,
      name: json['name'],
      pictureModel: PictureModel.fromJson(json['picture']['data']));
}

class PictureModel {
  final String? url;
  final int? width;
  final int? height;

  const PictureModel({this.width, this.height, this.url});

  factory PictureModel.fromJson(Map<String, dynamic> json) => PictureModel(
      url: json['url'], width: json['width'], height: json['height']);
}
