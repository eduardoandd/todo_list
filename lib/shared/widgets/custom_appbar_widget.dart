import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:intl/intl.dart';

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final DateTime pickDate;
  final Function(DateTime) onDateSelected;

  const CustomAppBarWidget(
      {Key? key, required this.pickDate, required this.onDateSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');

    return AppBar(
      title: Center(child: Text(dateFormat.format(pickDate))),
      actions: [
        IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () async {
            final selectedDate = await DatePicker.showSimpleDatePicker(
              context,
              titleText: "",
              initialDate: pickDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2090),
              dateFormat: "dd-MMMM-yyyy",
              locale: DateTimePickerLocale.pt_br,
              looping: true,
              cancelText: "Cancelar",
              confirmText: "Confirmar"
            );
            if (selectedDate != null) {
              onDateSelected(selectedDate);
            }
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
