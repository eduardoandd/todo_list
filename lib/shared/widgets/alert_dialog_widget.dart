// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';

class AlertDialogWidget extends StatefulWidget {
  final String title;
  final TextEditingController description;
  final Function(DateTime?, DateTime?, String) onSetTime;
  final Function(bool) onConfirm;
  final DateTime pickdate;

  const AlertDialogWidget(
      {Key? key,
      required this.title,
      required this.description,
      required this.onSetTime, 
      required this.pickdate, 
      required this.onConfirm})
      : super(key: key);

  @override
  State<AlertDialogWidget> createState() => _AlertDialogWidgetState();
}

class _AlertDialogWidgetState extends State<AlertDialogWidget> {
  Time _time = Time(hour: 12, minute: 0);
  Time? taskTime;
  Time? notifyTime;
  DateTime? notifyDateTime;
  DateTime? taskDateTime;

  String selectedTime = "Dia inteiro";
  bool fullDay = true;
  String notifyOption = '30 minutos antes';
  List<String> options = [
    "30 minutos antes",
    "1 hora antes",
    "2 horas antes",
    "Não exibir notificações",
  ];

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
            selectedTime =
                "${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}";
            fullDay = false;
            notifyTime =
                Time(hour: taskTime!.hour, minute: (taskTime!.minute - 30));
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
        children: [Text(widget.title), Column()],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: widget.description,
            decoration: InputDecoration(hintText: "Digite algo"),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _showTimePicker();
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: fullDay ? Colors.grey : Colors.purple,
                          size: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(selectedTime),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          selectedTime != 'Dia inteiro'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          final result = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Theme.of(context).colorScheme.background,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: options.map((option) => RadioListTile(
                                      activeColor: Theme.of(context).colorScheme.primary,
                                      value: option,
                                      title: Text(option, style: TextStyle(fontSize: 14)),
                                      groupValue: notifyOption,
                                      onChanged: (value) {
                                        if (value == '30 minutos antes') {
                                          notifyTime = Time(hour: taskTime!.hour, minute: (taskTime!.minute - 30));
                                          notifyDateTime = DateTime(widget.pickdate.year, widget.pickdate.month, widget.pickdate.day, notifyTime!.hour, notifyTime!.minute);
                                          taskDateTime = DateTime(widget.pickdate.year, widget.pickdate.month, widget.pickdate.day, taskTime!.hour, taskTime!.minute);
                                        } else if (value == "1 hora antes") {
                                          notifyTime = Time(hour: (taskTime!.hour - 1), minute: taskTime!.minute);
                                          notifyDateTime = DateTime(widget.pickdate.year, widget.pickdate.month, widget.pickdate.day, notifyTime!.hour, notifyTime!.minute);
                                          taskDateTime = DateTime(widget.pickdate.year, widget.pickdate.month, widget.pickdate.day, taskTime!.hour, taskTime!.minute);
                                        } else if (value == "2 horas antes") {
                                          notifyTime = Time(hour: (taskTime!.hour - 2), minute: taskTime!.minute);
                                          notifyDateTime = DateTime(widget.pickdate.year, widget.pickdate.month, widget.pickdate.day, notifyTime!.hour, notifyTime!.minute);
                                          taskDateTime = DateTime(widget.pickdate.year, widget.pickdate.month, widget.pickdate.day, taskTime!.hour, taskTime!.minute);
                                        } else if (value == 'Não exibir notificações') {
                                          notifyTime = null;
                                        } else {
                                          notifyTime = Time(hour: taskTime!.hour, minute: (taskTime!.minute - 30));
                                          notifyDateTime = DateTime(widget.pickdate.year, widget.pickdate.month, widget.pickdate.day, notifyTime!.hour, notifyTime!.minute);
                                          taskDateTime = DateTime(widget.pickdate.year, widget.pickdate.month, widget.pickdate.day, taskTime!.hour, taskTime!.minute);
                                        }

                                        setState(() {
                                          notifyOption = value.toString();
                                          Navigator.pop(context);
                                        });
                                      },
                                    )).toList(),
                                  ),
                                ),
                              );
                            });
                        },
                        borderRadius: BorderRadius.circular(50),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Row(children: [
                            Icon(Icons.notifications_rounded, size: 30),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(notifyOption),
                            )
                          ]),
                        ),
                      ),
                    )
                  ],
                )
              : Container(),
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
            // Verificar se o campo descrição está vazio
            if (widget.description.text.isEmpty) {
              // Exibir um alerta se o campo descrição estiver vazio
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Erro'),
                    content: Text('O campo descrição não pode estar vazio.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
              return; // Impede que a função continue se a descrição estiver vazia
            }

            // Verificar se a data de notificação é menor que a data atual
            if (notifyDateTime != null && notifyDateTime!.isBefore(DateTime.now())) {
              // Exibir um alerta se a data da notificação for menor que a data atual
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Erro'),
                    content: Text('A data da notificação não pode ser no passado.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
              return; // Impede que a função continue se a data da notificação for inválida
            }

            // Se as verificações passarem, chama as funções fornecidas
            widget.onSetTime(taskDateTime, notifyDateTime, notifyOption);
            widget.onConfirm(fullDay);
            Navigator.pop(context);
          },
          child: Text("Salvar"),
        ),
      ],
    );
  }
}
