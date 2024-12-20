// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

import 'alert_dialog_noticatin_widget.dart';

class CustomAlertDialog extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String confirmText;
  final Function onConfirm;
  final bool notify;
  final bool fullDay;
  final Function(bool) onfullDayChanged;
  final Function(Time) onTaskTimeChanged;

  CustomAlertDialog({
    required this.controller,
    required this.title,
    required this.confirmText,
    required this.onConfirm,
    required this.notify,
    required this.fullDay,
    required this.onfullDayChanged, required this.onTaskTimeChanged
  });

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  bool notification = false;
  Time _time = Time(hour: 12, minute: 0);
  String selectedTime = "Dia inteiro";
  Time? taskTime_;

  void _showTimePicker() {
    Navigator.of(context).push(
      showPicker(
        context: context,
        value: _time,
        onChange: (Time newTime) {
          setState(() {
            _time = newTime;
            taskTime_ = _time;
            selectedTime =
                "${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}";
              
              if(taskTime_ != null){
                widget.onTaskTimeChanged(taskTime_!);
              }

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: (){
                    _showTimePicker();
                    if(_time != null){
                      setState(() {
                        widget.onfullDayChanged(false);
                       
                      });
                    }
                  },
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
          selectedTime !="Dia inteiro" ? Row(
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
                            color: notification ? Colors.purple : Colors.grey),
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
          ) : Container(),
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
