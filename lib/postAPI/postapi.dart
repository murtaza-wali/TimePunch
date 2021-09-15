import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:rflutter_alert/rflutter_alert.dart';

class BaseURL {
  // String Auth = 'https://art.artisticmilliners.com:8081/ords/art/apis/';
  String Auth = 'https://artlive.artisticmilliners.com:8081/ords/art/';
}

class postJSON {
  ///timepunch/add_device/:access_key/:device_id/:device_model/:device_os/:ip_address
  Future<http.Response?> Postdevice(String access_key, String device_id,
      String device_model, String device_os, String ip_address, context) async {
    // Uri.parse must when you are passing URL.
    var deviceURL = Uri.parse(BaseURL().Auth +
        "timepunch/add_device/" +
        access_key +
        "/" +
        device_id +
        "/" +
        device_model +
        "/" +
        device_os +
        "/" +
        ip_address.toString());
    print('Device  url${deviceURL}');
    var deviceresult = await http.post(deviceURL);
    print('Device result${deviceresult.body}');
    if (deviceresult.statusCode == 200) {
      return deviceresult;
    } else {
      ErrorPopup(context, 'Error', 'Bad request error!', 'OK');
    }
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

  Future<http.Response?> PostemployeeAttendace(String employeecode) async {
    // Uri.parse must when you are passing URL.
    var deviceURL =
        Uri.parse(BaseURL().Auth + "timepunch/submit/" + employeecode);
    print('Device  url231${deviceURL}');
    var deviceresult = await http.post(deviceURL);
    print('Device result231${deviceresult.body}');
    if (deviceresult.statusCode == 200) {
      return deviceresult;
    }
  }
}
