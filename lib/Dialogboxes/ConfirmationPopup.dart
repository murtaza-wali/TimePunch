import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minimize_app/minimize_app.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

confirmationPopup(BuildContext dialogContext, String title, String msg,
    String okbtn, emplloyeename) {
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
      desc: 'Hi, ' + emplloyeename + msg,
      buttons: [
        DialogButton(
          child: Text(
            okbtn,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            closeApp();
            /*Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ListenLocationWidget()),
                  (Route<dynamic> route) => false);*/
          },
          color: Colors.black,
        ),
      ]).show();
}

confirmationPopupwithoutEmployeeName(
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
            closeApp();
          },
          color: Colors.black,
        ),
      ]).show();
}

void closeApp() {
  if (Platform.isAndroid) {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  } else {
    MinimizeApp.minimizeApp();
  }
}
