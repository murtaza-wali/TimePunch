import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

var postChecked=false;
var ecode;
Future<http.Response> postAttendance() async {
  final response = Uri.parse(
      'https://artlive.artisticmilliners.com:8081/ords/art/timepunch/submit/' +
          '${ecode}');
  var attendanceResult = await http.post(response);
  if (attendanceResult.statusCode == 200) {
    postChecked = true;
    return attendanceResult;
  } else {
    postChecked = false;
  }
  postChecked = false;
  return attendanceResult;
}

class SuccessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text('Your Attendance have been marked',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,)
        ],
      ),
    );
  }
}
