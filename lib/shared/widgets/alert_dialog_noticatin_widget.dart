import 'package:flutter/material.dart';

class AlertDialogNotificationWidget extends StatefulWidget {
  const AlertDialogNotificationWidget({Key? key}) : super(key: key);

  @override
  State<AlertDialogNotificationWidget> createState() => _AlertDialogNotificationWidgetState();
}

class _AlertDialogNotificationWidgetState extends State<AlertDialogNotificationWidget> {
  final List<String> options = [
    "30 minutos antes",
    "1 hora antes",
    "2 horas antes",
    "Personalizado",
  ];
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), 
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
      backgroundColor: Colors.white, 
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: options
              .map((option) => RadioListTile<String>(
                    title: Text(
                      option,
                      style: const TextStyle(fontSize: 14), 
                    ),
                    value: option,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                  ))
              .toList(),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 8), 
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, selectedOption),
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
