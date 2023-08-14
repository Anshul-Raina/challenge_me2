import 'package:challenge_me2/event_data_source.dart';
import 'package:challenge_me2/event_provider.dart';
import 'package:challenge_me2/model/event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({super.key});

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final selectedEvents = provider.eventsOfSelectedDate;
    if (selectedEvents.isEmpty) {
      return const Center(child: Text('No Events found!'));
    }
    return SfCalendar(
      headerHeight: 0,
      view: CalendarView.timelineDay,
      dataSource: EventDataSource(provider.events),
      initialDisplayDate: provider.selectedDate,
      appointmentBuilder: appointmentBuilder,
    );
  }

  Widget appointmentBuilder(
    BuildContext context,
    CalendarAppointmentDetails details,
  ) {
    final event = details.appointments.first;
    return Container(
        width: details.bounds.width,
        height: details.bounds.height,
        decoration: BoxDecoration(
            color: Colors.amber, borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Text(event.title,
              maxLines: 2,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
        ));
  }
}
