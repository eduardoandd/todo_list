import 'package:flutter/material.dart';
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
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: pickDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
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
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight); 
}
