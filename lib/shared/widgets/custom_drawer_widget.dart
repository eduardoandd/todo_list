// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomDrawerWidget extends StatefulWidget {
  const CustomDrawerWidget({Key? key}) : super(key: key);

  @override
  State<CustomDrawerWidget> createState() => _CustomDrawerWidgetState();
}

class _CustomDrawerWidgetState extends State<CustomDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Tasks",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            accountEmail: Text(
              "tasks@gmail.com",
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            decoration: BoxDecoration(
                color: Colors.purple.shade600,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            leading: Icon(
              Icons.star,
              size: 30,
              color: Colors.purple.shade600,
            ),
            title: Text("Tasks Plus",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.brush,
              size: 30,
              color: Colors.purple.shade600,
            ),
            title: Text("Temas",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.handshake_rounded,
              size: 30,
              color: Colors.purple.shade600,
            ),
            title: Text("Doação",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.question_mark,
              size: 30,
              color: Colors.purple.shade600,
            ),
            title: Text("FAQ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            onTap: () {},
          ),
          Divider(),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Versão 1.0", style: TextStyle(
              fontSize: 18,
              color: Colors.purple.shade600,
              fontWeight: FontWeight.w400
            ),),
          ),


        ],
      ),
    );
  }
}
