import 'package:challenge_me2/widget/tasks_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../event_data_source.dart';
import '../model/event_editing_page.dart';
import '../event_provider.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge Me'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline_sharp,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EventEditingPage(),
                ),
              );
            },
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(border: Border.all(color: Colors.red)),
              height: 500,
              child: SfCalendar(
                onLongPress: (details) {
                  final provider =
                      Provider.of<EventProvider>(context, listen: false);
                  provider.setDate(details.date!);
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => const TasksWidget(),
                  );
                },
                dataSource: EventDataSource(events),
                view: CalendarView.month,
                initialSelectedDate: DateTime.now(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
