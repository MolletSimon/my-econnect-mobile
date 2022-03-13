import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:my_econnect/models/appointments.dart';
import 'package:my_econnect/pages/agenda/widgets/index.dart';
import 'package:my_econnect/services/agendaService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../models/posts/group.dart';
import '../../models/user.dart';
import '../../services/userService.dart';
import '../../utils/utils.dart';

class AgendaPage extends StatefulWidget {
  AgendaPage({Key? key}) : super(key: key);

  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  User currentUser = UserService().initEmptyUser();
  Utils utils = new Utils();
  List<AppointmentConnect> appointments = [];

  @override
  void initState() {
    _getAppointments();
    super.initState();
  }

  void _getAppointments() async {
    await _getCurrentUser();
    AgendaService().getAppointments(currentUser).then((value) => {
          setState(() => {
                appointments = AppointmentConnect.appointmentConnectList(
                    jsonDecode(value!.body))
              }),
        });
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    for (var i = 0; i < appointments.length; i++) {
      meetings.add(Meeting(
        eventName: appointments[i].subject,
        from: appointments[i].startTime.add(const Duration(days: 1)),
        to: appointments[i].endTime,
        background: utils.colorConvert(appointments[i].group["color"]),
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
            backgroundColor: Theme.of(context).primaryColor,

            textStyle: TextStyle(
                fontSize: 25,
                fontStyle: FontStyle.normal,
                letterSpacing: 2,
                color: Color(0xFFff5eaea),
                fontWeight: FontWeight.w500)),
        firstDayOfWeek: 1,
      ),
    );
  }
}
