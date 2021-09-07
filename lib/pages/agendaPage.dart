import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AgendaPage extends StatefulWidget {
  AgendaPage({Key? key}) : super(key: key);

  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfCalendar(
        view: CalendarView.month,
        headerStyle: CalendarHeaderStyle(
            textAlign: TextAlign.center,
            backgroundColor: Color(0xFF23439B),
            textStyle: TextStyle(
                fontSize: 25,
                fontStyle: FontStyle.normal,
                letterSpacing: 5,
                color: Color(0xFFff5eaea),
                fontWeight: FontWeight.w500)),
        firstDayOfWeek: 1,
      ),
    );
  }
}
