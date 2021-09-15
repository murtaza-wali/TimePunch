import 'dart:convert';

import 'package:am_timepunch/postAPI/postapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_ip/get_ip.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'DeviceInfo/DeviceIdentifier.dart';
import 'DeviceInfo/DeviceModel.dart';
import 'DeviceInfo/DeviceOS.dart';
import 'DeviceInfo/DeviceVersion.dart';
import 'LocalStorage/MySharedPref.dart';
import 'listen_location.dart';
import 'main.dart';

class Accesskey extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccesskeyState();
}

class _AccesskeyState extends State<Accesskey> {
  String _ip = 'Unknown';
  late String _os,
      _version,
      _model,
      _udid,
      active,
      value,
      _value,
      emp_name,
      empcode,
      akey;
  bool firsttime = false;
  late int val;
  TextEditingController accessIdController = TextEditingController();
  bool isloading = false;
  late ProgressDialog progressDialog;
  late int status;

  @override
  void initState() {
    super.initState();
    progressDialog = new ProgressDialog(context);
    initPlatformState();
    getDeviceIdentifier().then((udid) {
      _udid = udid;
      print('UDID: ${_udid}');
    });
    getDeviceOS().then((os) {
      _os = os;
      print('_os: ${_os}');
    });
    getDeviceModel().then((model) {
      _model = model!;
      print('_model: ${_model}');
    });
    getDeviceVersion().then((version) {
      _version = version!;
      print('_version: ${_version}');
    });
  }

  Future<void> initPlatformState() async {
    String ipAddress;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      ipAddress = await GetIp.ipAddress;
    } on PlatformException {
      ipAddress = 'Failed to get ipAddress.';
    }
    if (!mounted) return;

    setState(() {
      _ip = ipAddress;
      print('IP Address: ${_ip}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('\u{1F510} Access Key'),

      ),
      body: Align(
        alignment: Alignment.center,
        child: Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Enter your Access key',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
                Container(
                    margin: EdgeInsets.all(2),
                    child: TextField(
                      controller: accessIdController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF09E812), width: 1.0),
                        ),
                        border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey, width: 0.0),),
                        labelText: 'Access ID',
                          labelStyle: TextStyle(
                              color: Color(0xFF09E812),
                          )
                      ),
                      onChanged: (accesstext) {
                        setState(() {});
                      },
                    )),
                Container(
                  child: Center(
                    child: FlatButton(
                      color: Colors.white,
                      textColor: Colors.black,
                      child: Text('Validate'),
                      onPressed: () {
                        setState(() {
                          // yahan api hit honi hai ....
                          if (accessIdController.text.isEmpty) {
                            ErrorPopup(context, 'Alert',
                                'All fields are required', 'OK');

                          }
                          else {
                            postJSON()
                                .Postdevice(
                              accessIdController.text,
                              _udid,
                              _model,
                              _os,
                              _ip,
                              context
                            )
                                .then((value) {
                              Map<String, dynamic> user =
                                  jsonDecode(value!.body);
                              status = user['status'];
                              active = user['isactive'];
                              akey = user['akey'];
                              empcode = user['empcode'];
                              emp_name = user['emp_name'];
                              print('empcode${empcode}');

                              if (status == 200) {
                                print('status: ${status}');
                                MySharedPreferences.instance
                                    .setIntValue("status", status);
                                MySharedPreferences.instance
                                    .setStringValue("active", active);
                                MySharedPreferences.instance
                                    .setStringValue("akey", akey);
                                MySharedPreferences.instance
                                    .setStringValue("empcode", empcode);
                                MySharedPreferences.instance
                                    .setStringValue("emp_name", emp_name);
                                confirmationPopup(context, 'Success',
                                    'Successfully Registered!', 'OK');
                              } else if (status == 404) {
                                ErrorPopup(context, 'Error',
                                    'Invalid Key Entered !', 'OK');
                              }
                            });
                          }
                          /*else {
                          ErrorPopup(context, 'Error',
                          'Enter Invalid Ke!', 'OK');
                          }*/
                        });
                      },
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  ErrorPopup(
      BuildContext dialogContext, String title, String msg, String okbtn) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
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
              Navigator.pop(context);
            },
            color: Colors.black,
          ),
        ]).show();
  }

  confirmationPopup(
      BuildContext dialogContext, String title, String msg, String okbtn) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
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
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ListenLocationWidget()),
                  (Route<dynamic> route) => false);
            },
            color: Colors.black,
          ),
        ]).show();
  }
}
