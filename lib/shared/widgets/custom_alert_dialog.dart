// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String confirmText;
  final Function onConfirm;
  final IconData icon;
  final IconData icon2;
  final VoidCallback onIconPressed;
  final VoidCallback onIconPressed2;
  final String timeNotification;
  final String timeTask;
  // final bool visible;
  final bool borderIsVisible;

  CustomAlertDialog({
    required this.controller,
    required this.title,
    required this.confirmText,
    required this.onConfirm,
    required this.icon,
    required this.icon2,
    required this.onIconPressed,
    required this.onIconPressed2,
    required this.timeNotification,
    required this.timeTask,
    // required this.visible,
    required this.borderIsVisible
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Column(
            children: [
              IconButton(
                onPressed: onIconPressed,
                icon: Icon(icon)
              ),
              Text(timeNotification, style: TextStyle(fontSize: 12),)
            ],
          )
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 20),
                padding: EdgeInsets.symmetric(vertical: 8),
                decoration: borderIsVisible ? BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey[400]!, width: 1),
                )
                :
                BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Color.fromARGB(255, 255, 255, 255)!, width: 1),
                )

                ,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: onIconPressed2,
                      icon: Icon(icon2)
                    ),
                    
                    SizedBox(width: 8),
                    Text(
                      timeTask,
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                    SizedBox(width: 8),
                    
                    // Visibility(
                    //   visible:  visible,
                    //   child: Icon(Icons.close, color: Colors.red[600], size: 20,)
                    // ),
                    

                  ],
                ),
              )

              // Icon(Icons.access_time),
              

            ],
          ),
        ],
      ),
      

      actions: [
        TextButton(
          onPressed: () {
            
            Navigator.pop(context);
          }, 
          child: Text('Cancelar')
        ),

        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          }, 
          child: Text(confirmText),
        )
      ],
    );
  }

}