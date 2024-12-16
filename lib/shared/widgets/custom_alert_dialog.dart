// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String confirmText;
  final Function onConfirm;
  // final bool visible;
  final bool borderIsVisible;

  CustomAlertDialog(
      {required this.controller,
      required this.title,
      required this.confirmText,
      required this.onConfirm,
      required this.borderIsVisible});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title), Column()],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 20),
                padding: EdgeInsets.symmetric(vertical: 8),
                decoration: borderIsVisible
                    ? BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.grey[400]!, width: 1),
                      )
                    : BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                            color: Color.fromARGB(255, 255, 255, 255)!,
                            width: 1),
                      ),
                child: Row(
                  children: [
                    SizedBox(width: 8),
                    SizedBox(width: 8),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancelar')),
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
