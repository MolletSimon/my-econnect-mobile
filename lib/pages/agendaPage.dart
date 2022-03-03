import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:my_econnect/models/appointments.dart';
import 'package:my_econnect/services/agendaService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../models/posts/group.dart';
import '../models/user.dart';
import '../services/userService.dart';

class AgendaPage extends StatefulWidget {
  AgendaPage({Key? key}) : super(key: key);

  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  User currentUser = UserService().initEmptyUser();
  List<AppointmentConnect> appointments = [];

  @override
  void initState() {
    _getAppointments();
    super.initState();
  }

  void _getAppointments() async {
    await _getCurrentUser();
    AgendaService().getAppointments(currentUser).then((value) => {
          print(value!.body),
          setState(() => {
                appointments = AppointmentConnect.appointmentConnectList(
                    jsonDecode(value.body))
              }),
          print(appointments[0])
        });
  }

  Color colorConvert(String color) {
    color = color.replaceAll("#", "");
    if (color.length == 6) {
      return Color(int.parse("0xFF" + color));
    } else if (color.length == 8) {
      return Color(int.parse("0x" + color));
    }

    return Colors.white;
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    for (var i = 0; i < appointments.length; i++) {
      meetings.add(Meeting(
        eventName: appointments[i].subject,
        from: appointments[i].startTime.add(const Duration(days: 1)),
        to: appointments[i].endTime,
        background: colorConvert(appointments[i].group["color"]),
        isAllDay: appointments[i].isAllDay,
      ));
    }

    return meetings;
  }

  Future<void> _getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "null";
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    currentUser = User.oneUser(decodedToken);

    if (currentUser.isSuperadmin) {
      UserService().getGroups(currentUser).then((value) => {
            if (value!.statusCode == 200)
              {
                if (mounted)
                  {
                    setState(() {
                      currentUser.groups =
                          Group.groupsList(jsonDecode(value.body));
                    })
                  }
              }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfCalendar(
        dataSource: AppDataSource(_getDataSource()),
        view: CalendarView.month,
        monthViewSettings: MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
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

class AppDataSource extends CalendarDataSource {
  AppDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(
      {this.eventName = '',
      required this.from,
      required this.to,
      required this.background,
      this.isAllDay = false});

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
