// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/pages/todo_page.dart';
import 'package:uuid/uuid.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? userId = '';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp()async{
    await Future.delayed(const Duration(seconds: 2));
    loadUser();
  }

  loadUser(){
    Future.delayed(Duration(seconds: 2), () async {
      final prefs = await SharedPreferences.getInstance();
      userId= prefs.getString('user_id');

      if (userId == null){
        var uuiD = Uuid();
        userId = uuiD.v4();
        prefs.setString('user_id', userId.toString());
      }

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TodoPage()));
    });
  }

  void navigateHome(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TodoPage()),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Column(
        children: [
          Image.asset(
            'assets/app/logo.png', 
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 20),
          const CircularProgressIndicator(),
        ],
      ),),
    );
  }
}