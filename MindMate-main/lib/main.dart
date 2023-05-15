import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
 import 'package:mark1/screens/welcome_screen.dart';
 import 'package:mark1/screens/login_screen.dart';
 import 'package:mark1/screens/registration_screen.dart';
 import 'package:mark1/screens/chat_screen.dart';
 import 'package:mark1/screens/chatgpt_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}



class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id:(context)=> WelcomeScreen(),
        LoginScreen.id:(context)=> LoginScreen(),
        RegistrationScreen.id:(context)=> RegistrationScreen(),
        ChatScreen.id:(context)=> ChatScreen(),
        ChatGPTScreen.id:(context)=>ChatGPTScreen(),

      },
    );
  }
}
