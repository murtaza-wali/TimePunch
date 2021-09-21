import 'dart:convert';
import 'dart:io';

import 'package:am_timepunch/postAPI/postapi.dart';
import 'package:am_timepunch/postAPI/validate_class.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

import 'currenttime_class.dart';

class getApi {

  Future<List<Item>?> getvalidate(context ,String key) async {
    // Uri.parse must when you are passing URL.
    try{
      var validateURL =
      Uri.parse(BaseURL().Auth + "timepunch/validate/" + key.toString());

      final GPresult = await http.get(validateURL);

      var parse = json.decode(GPresult.body);
      var data = parse['items'] as List;
      var GPmap = data.map<Item>((json) => Item.fromJson(json));
      if (GPresult.statusCode == 200) {
        return GPmap.toList();
      }else{
        return null;
      }
    }on SocketException catch (e) {
      throw ErrorPopup(context, 'Socket Exception',
          'Check Internet Connectivity ', 'OK');
    }
  }
  bool checked = false;
  var currTime;
  Future<List<CurrentTimeitem>?> getCurrentTime(BuildContext context) async {
    try{
      final response = Uri.parse(
          'https://artlive.artisticmilliners.com:8081/ords/art/timepunch/time');
      print('response: ${response}');
      var atttime = await http.get(response);

      var parse = json.decode(atttime.body);
      var data = parse["items"] as List;
      print('check logging${data}');
      var map = data.map<CurrentTimeitem>((json) => CurrentTimeitem.fromJson(json));
      if (atttime.statusCode == 200) {
        print('check logging1${map}');
        checked = true;
        return map.toList();
      }else{
        checked = false;
        currTime = '';
      }
    }on SocketException catch (e) {
      throw e.message;
    }

    /* if (atttime.statusCode == 200) {
    checked = true;
    return atttime;
  } else {
    checked = false;
    currTime = '';
  }
  checked = false;
  return atttime;*/
  }
  ErrorPopup(
      BuildContext dialogContext, String title, String msg, String okbtn) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );
    Alert(
        context: dialogContext,
        style: alertStyle,
        title: title,
        desc: msg,
        buttons: [
          DialogButton(
            child: Text(
              okbtn,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            color: Colors.black,
          ),
        ]).show();
  }
}
