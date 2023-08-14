import 'package:challenge_me2/widget/calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'event_provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: const MaterialApp(
        home: Scaffold(
          body: CalendarWidget(),
        ),
      ),
    );
  }
}
