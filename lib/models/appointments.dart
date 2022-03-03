import 'package:my_econnect/models/posts/group.dart';

class AppointmentConnect {
  final String? description;
  final DateTime endTime;
  final dynamic group;
  final bool isAllDay;
  final String? location;
  final String? reccurenceRule;
  final DateTime startTime;
  final String subject;
  final String id;

  AppointmentConnect(
      {this.description,
      required this.endTime,
      required this.group,
      required this.isAllDay,
      this.location,
      this.reccurenceRule,
      required this.startTime,
      required this.subject,
      required this.id});

  Map toJson() => {
        'Description': description,
        'Endtime': endTime,
        '_id': id,
        'Group': group,
        'IsAllDay': isAllDay,
        'Location': location,
        'RecurrenceRule': reccurenceRule,
        'StartTime': startTime,
        'Subject': subject
      };

  //Method
  static List<AppointmentConnect> appointmentConnectList(List<dynamic> body) {
    List<AppointmentConnect> l = [];

    List<dynamic> results = body;

    results.forEach((value) {
      AppointmentConnect appointmentConnect = AppointmentConnect(
        description: value["Description"],
        endTime: DateTime.parse(value["EndTime"]),
        group: value["Group"],
        id: value['_id'],
        isAllDay: value['IsAllDay'],
        location: value['Location'],
        reccurenceRule: value['RecurrenceRule'],
        startTime: DateTime.parse(value['StartTime']),
        subject: value['Subject'],
      );
      l.add(appointmentConnect);
    });

    return l;
  }
}
