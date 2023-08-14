import 'dart:async';

import 'package:challenge_me2/model/event.dart';
import 'package:challenge_me2/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../event_provider.dart';

class EventEditingPage extends StatefulWidget {
  const EventEditingPage({super.key, this.event});
  final Event? event;
  @override
  State<EventEditingPage> createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  final titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late DateTime fromDate;
  late DateTime toDate;
  @override
  void initState() {
    super.initState();
    fromDate = DateTime.now();
    toDate = fromDate.add(
      const Duration(hours: 2),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final event = Event(
        title: titleController.text,
        description: 'Description',
        from: fromDate,
        to: toDate,
        isAllDay: false,
      );
      final provider = Provider.of<EventProvider>(context, listen: false);
      provider.addEvent(event);
      Navigator.of(context).pop();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Challenge'),
        actions: [
          IconButton(
            onPressed: () => saveForm(),
            icon: const Icon(
              Icons.done,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: buildTitle(),
                ),
              ),
              buildDateTimePickers(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitle() => TextFormField(
        validator: (title) => title != null && title.isEmpty
            ? 'Challenge Title cannot be empty'
            : null,
        style: const TextStyle(fontSize: 24),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Add challenge title',
        ),
        onFieldSubmitted: (_) {
          saveForm();
        },
        controller: titleController,
      );
  Widget buildDateTimePickers() => Column(
        children: [
          buildFrom(),
          buildTo(),
        ],
      );
  Widget buildFrom() => buildHeader(
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.lightBlueAccent,
                )),
                child: buildDropdownField(
                  text: Utils.toDate(
                    fromDate,
                  ),
                  onClicked: () {
                    pickFromDateTime(pickDate: true);
                  },
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.lightBlueAccent)),
                child: buildDropdownField(
                  text: Utils.toTime(
                    fromDate,
                  ),
                  onClicked: () {
                    pickFromDateTime(pickDate: false);
                  },
                ),
              ),
            ),
          ],
        ),
        header: 'FROM',
      );
  Widget buildTo() => buildHeader(
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.lightBlueAccent,
                )),
                child: buildDropdownField(
                  text: Utils.toDate(
                    toDate,
                  ),
                  onClicked: () {
                    pickToDateTime(pickDate: true);
                  },
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.lightBlueAccent)),
                child: buildDropdownField(
                  text: Utils.toTime(
                    toDate,
                  ),
                  onClicked: () {
                    pickToDateTime(pickDate: false);
                  },
                ),
              ),
            ),
          ],
        ),
        header: 'TO',
      );
  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    if (date == null) {
      return;
    }
    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }
    setState(() => fromDate = date);
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(
      toDate,
      pickDate: pickDate,
      firstDate: pickDate ? fromDate : null,
    );
    if (date == null) {
      return;
    }
    setState(() => toDate = date);
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime(2023, 1),
          lastDate: DateTime(2101));

      if (date == null) return null;
      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (timeOfDay == null) return null;
      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }

  Widget buildDropdownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        title: Text(text),
        trailing: const Icon(
          Icons.arrow_drop_down,
        ),
        onTap: onClicked,
      );

  Widget buildHeader({
    required Widget child,
    required String header,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              header,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          child,
        ],
      );
}
