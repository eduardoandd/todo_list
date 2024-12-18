// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

import 'alert_dialog_noticatin_widget.dart';

class CustomAlertDialog extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String confirmText;
  final Function onConfirm;

  CustomAlertDialog({
    required this.controller,
    required this.title,
    required this.confirmText,
    required this.onConfirm,
  });

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  bool notification = false;
  Time _time = Time(hour: 12, minute: 0);
  String selectedTime = "Adicionar horário";

  void _showTimePicker() {
    Navigator.of(context).push(
      showPicker(
        context: context,
        value: _time,
        onChange: (Time newTime) {
          setState(() {
            _time = newTime;
            selectedTime =
                "${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}";
          });
        },
        iosStylePicker: false,
        is24HrFormat: true,
        minuteInterval: TimePickerInterval.FIVE,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title),
          Column(),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: "Digite algo",
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _showTimePicker,
                  borderRadius: BorderRadius.circular(50),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 30,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(selectedTime),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    final result = await showDialog<String>(
                        context: context,
                        builder: (BuildContext bc) {
                          return AlertDialogNotificationWidget();
                        });
                    if (result != null) {
                      setState(() {
                        notification = true;
                      });
                    }
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.notifications_rounded,
                            size: 30,
                            color: notification ? Colors.blue : Colors.grey),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Adicionar notificação"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (notification)
                InkWell(
                  onTap: () {
                    setState(() {
                      notification = false;
                    });
                  },
                  child: Container(
                    // padding: const EdgeInsets.only( bottom: 10),
                    child: Icon(Icons.close, size: 25, color: Colors.red),
                  ),
                ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            widget.onConfirm();
            Navigator.pop(context);
          },
          child: Text(widget.confirmText),
        ),
      ],
    );
  }
}
