import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'login_screen.dart';
import 'registration_screen.dart';
import '../components/rounded_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:firebase_core/firebase_core.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = '/WelcomeScreen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  bool _initialized = false;
  bool _error = false;
  var _auth;

  Future<void> initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      // this._auth = FirebaseAuth.instance;
      // this._auth.authStateChanges().listen((User user) {
      //   if (user == null) {
      //     print('user is currently signed out!');
      //   } else {
      //     print(user);
      //     print('user is signed in');
      //   }
      // });
      setState(() {
        this._initialized = true;
        print('initialized = ${this._initialized}');
      });
    } catch (e) {
      setState(() {
        this._error = true;
      });
    }
  }

  Future<void> signout() async {
    print(this._auth);
    if (this._auth != null) {
      await this._auth.signOut();
    }
  }

  @override
  void initState() {
    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation =
        controller.drive(ColorTween(begin: Colors.blueGrey, end: Colors.white));
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
    this.initializeFlutterFire();
    super.initState();
  }

  @override
  void dispose() {
    this.signout();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: ModalProgressHUD(
        inAsyncCall: !this._initialized,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    child: Hero(
                      tag: 'logo',
                      child: Container(
                        child: Image.asset('images/logo.png'),
                        height: 60.0,
                      ),
                    ),
                  ),
                  TypewriterAnimatedTextKit(
                    speed: Duration(milliseconds: 300),
                    repeatForever: false,
                    totalRepeatCount: 1,
                    text: ['Flash Chat'],
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 48.0,
              ),
              RoundedButton(
                color: Colors.lightBlueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                text: 'Log in',
              ),
              RoundedButton(
                color: Colors.blueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                text: 'Register',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
