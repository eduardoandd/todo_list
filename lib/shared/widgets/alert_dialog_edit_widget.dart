// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AlertDialogEditWidget extends StatefulWidget {
  final TextEditingController description;
  final Function(DateTime?)? onSetTime;
  final DateTime? taskTimeSelected;
  final DateTime pickDate;
  final  Function() onConfirm;


  const AlertDialogEditWidget({Key? key, required this.description, this.taskTimeSelected, this.onSetTime, required this.pickDate, required this.onConfirm}) : super(key: key);

  @override
  State<AlertDialogEditWidget> createState() => _AlertDialogEditWidgetState();
}

class _AlertDialogEditWidgetState extends State<AlertDialogEditWidget> {
  Time _time = Time(hour: 12, minute: 0);
  bool fullDay = true;
  Time? taskTime;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.taskTimeSelected == null ? fullDay = true : fullDay = false;
    
    if(fullDay == false){
      setState(() {
        taskTime = Time(hour: widget.taskTimeSelected!.hour, minute: widget.taskTimeSelected!.minute);
      });
    }
    

  }


  @override
  void _showTimePicker() {
    Navigator.of(context).push(
      showPicker(
        backgroundColor: Theme.of(context).colorScheme.background,
        accentColor: Theme.of(context).colorScheme.primary,
        context: context,
        value: _time,
        onChange: (Time newTime) {
          setState(() {
            _time = newTime;
            taskTime = _time;
            fullDay = false;

            // selectedTime =
            //     "${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}";
            // fullDay = false;
            // notifyTime =
            //     Time(hour: taskTime!.hour, minute: (taskTime!.minute - 30));
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
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text('Editar tarefa')],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: widget.description,
            decoration: InputDecoration(hintText: "Digite algo"),
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap:(){
                    _showTimePicker();
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: fullDay ?Colors.grey : Colors.purple,
                          size: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(fullDay? 'Dia inteiro' : taskTime.toString().replaceAll('TimeOfDay(', '').replaceAll(')', '')),
                        ),
                      ],
                    ),

                  ),
                ),
                
              )
            ],
          )
        ],
      ),
      actions: [
        TextButton(onPressed: (){ Navigator.pop(context);}, child: Text("Cancelar")),
        TextButton(
          onPressed: (){
            if(fullDay == false){
              DateTime finalTaskTime = DateTime(widget.pickDate.year,widget.pickDate.month,widget.pickDate.day,taskTime!.hour,taskTime!.minute);
              
              widget.onSetTime!(finalTaskTime);
            }
            widget.onConfirm();
            Navigator.pop(context);
          }, 
           child: Text("Salvar")
        )

      ],
    );
    
  }
}