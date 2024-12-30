// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/pages/drawer_pages/tutorial/tutorial_page.dart';
import 'package:todo_list/services/dark_mode_service.dart';

import '../../pages/drawer_pages/donation/donation_page.dart';
import '../../pages/drawer_pages/tasks_plus/tasks_plus_page.dart';

class CustomDrawerWidget extends StatefulWidget {
  const CustomDrawerWidget({Key? key}) : super(key: key);

  @override
  State<CustomDrawerWidget> createState() => _CustomDrawerWidgetState();
}

class _CustomDrawerWidgetState extends State<CustomDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    var darkModeService = Provider.of<DarkModeService>(context);
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity, 
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple.shade600,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )
              ), child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Task's", style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Raleway',
                    shadows: [
                      Shadow(
                        blurRadius: 5,
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(2, 2),
                      )
                    ],
                    
                  ),),
                  Padding(
                    padding: const EdgeInsets.only(bottom:8.0,top: 8.0),
                    child: Text(
                      "Gerencie suas tarefas com simplicidade",
                      style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                ],
              ),

              
              
            ),
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TasksPlusPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.dark_mode,
              size: 30,
              color: Colors.purple.shade600,
            ),
            title: Text("Modo Escuro",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            trailing: Consumer<DarkModeService>(
                builder: (_, darkModeService, widget) {
              return Switch(
                value: darkModeService.darkMode,
                onChanged: (bool value) {
                  setState(() {
                    darkModeService.darkMode = value;
                  });
                },
                activeColor: Colors.purple.shade600,
                inactiveThumbColor: Colors.purple.shade200,
                inactiveTrackColor: Colors.purple.shade100,
              );
            }),
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DonationPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.question_mark,
              size: 30,
              color: Colors.purple.shade600,
            ),
            title: Text("Tutorial",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TutorialPage()),
              );
            },
          ),
          Divider(),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Versão 1.0",
              style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.purple.shade600,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
