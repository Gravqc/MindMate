import 'package:flutter/material.dart';

import 'package:mark1/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mark1/screens/chatgpt_screen.dart';
late User loggedInUser ;
class ChatScreen extends StatefulWidget {
  static const String id = "chat_screen";
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User loggedInUser ;
  late String messageText;
  final messageTextController = TextEditingController();
  bool isTextFieldEmpty =true;

  void initState(){
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async{
    try{
    final user = await _auth.currentUser;
    if(user!=null){
      loggedInUser = user;

    }}
        catch(e){
      print(e);
        }

  }

  // void getMessages() async{
  //   final messages= await _firestore.collection('messages').get();
  //   for(var message in messages.docs){
  //     print(message.data());
  //   }
  // }
  void messegesStream() async{
    await for(var snapshot in _firestore.collection('messages').snapshots()){
      for(var message in snapshot.docs){
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[

          IconButton(
              icon:  ImageIcon(
                AssetImage('images/gpt.png'),
                color: Colors.green,
                size: 25,
              ),

              onPressed: () {

                Navigator.pushNamed(context, ChatGPTScreen.id);
                // _auth.signOut();
                // Navigator.pop(context);
              }),
          IconButton(
              icon:  ImageIcon(
                AssetImage('images/logout.png'),
                color: Colors.red,
                size: 20,
              ),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                Navigator.pop(context);
              }),
        ],
        title: Text('MindMate Chat'),
        backgroundColor:Color(0xFF0D2329),
      ),


      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').orderBy('timestamp').snapshots(),
              builder: (context,snapshot) {
                if(!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Color(0xFF164E5D),
                    ),
                  );
                }
                  final messages = snapshot.data?.docs;
                  List<MessageBubble> messageBubbles =[];
                  for(var message in messages!){
                    final messageText = message.get('text');
                    final messageSender = message.get('sender');

                    final currentUser = loggedInUser.email;




                    final messageBubble =
                        MessageBubble(sender: messageSender, text: messageText,isMe:currentUser==messageSender,);
                    messageBubbles.add(messageBubble);
                  }
                  return Expanded(
                    child: ListView(

                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                      children: messageBubbles,
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
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                        setState(() {
                          // Update the emptiness state of the text field
                           isTextFieldEmpty = value.isEmpty;
                        });
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  Container(
                    margin:  EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                      child: Text(
                        'Send',
                      ),
                      onPressed: isTextFieldEmpty? null : () {
                        messageTextController.clear();
                      _firestore.collection('messages').add({
                    'text':messageText,
                    'sender':loggedInUser.email,
                    'timestamp': DateTime.now(),
                  });
    },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF0D2329)),
                      ),
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

class MessageBubble extends StatelessWidget {
   MessageBubble({required this.sender,required this.text, required this.isMe});
final String sender;
final String text;
final bool isMe;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end: CrossAxisAlignment.start,
        children:<Widget> [
          Text(
              sender,
              style: TextStyle(
            color: Color(0xFF23839D),
          ),
          ),
          Material(
            elevation: 5.0,
            color: isMe ?  Color(0xFF083B50):Colors.blueGrey,
            borderRadius: isMe ? BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0,),
                bottomRight: Radius.circular(30.0)
            )
                : BorderRadius.only(
                bottomLeft: Radius.circular(30.0,),
                bottomRight: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),


            child: Padding(
              padding:  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                '$text',
                style:  TextStyle(
                  fontSize: 20.0,
                ),

              ),
            ),
          ),
        ],
      ),
    );
  }
}
