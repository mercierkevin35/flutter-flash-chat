import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/bubble.dart';

class ChatScreen extends StatefulWidget {
  static String id = '/ChatScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference messages;
  String message = '';
  bool loading = false;
  TextEditingController controller = TextEditingController();
  //TODO: implement loader

  @override
  void initState() {
    print('logged in as ${_auth.currentUser.email}');
    super.initState();
  }

  Future<void> sendMessage(String message) {
    return this
        .messages
        .add(
          {
            'sender': this._auth.currentUser.email,
            'text': message,
            'sentAt': FieldValue.serverTimestamp(),
          },
        )
        .then((value) => print('message : $message envoyé'))
        .catchError((error) =>
            print('failed to send message $message with error $error'));
  }

  @override
  Widget build(BuildContext context) {
    this.messages = this.firestore.collection('messages');

    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                //Implement logout functionality
                try {
                  await this._auth.signOut();
                  print('User logged out');
                  Navigator.pop(context);
                } catch (e) {
                  print(e.code);
                }
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream:
                  this.messages.orderBy('sentAt', descending: true).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                this.loading = false;
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  this.loading = true;
                  return Text('Loading');
                }

                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      String text = document.data()['text'];
                      String sender = document.data()['sender'];
                      return Bubble(
                          text: text,
                          sender: sender,
                          isMe: this._auth.currentUser.email == sender);
                      // return ListTile(
                      //   title: Text(text),
                      //   subtitle: Text(sender),
                      // );
                    }).toList(),
                  ),
                );
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: this.controller,
                      onChanged: (value) {
                        //Do something with the user input.
                        this.message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      if (this.message != '') {
                        this.sendMessage(this.message);
                      }
                      this.message = '';
                      this.controller.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
