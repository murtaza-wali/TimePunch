import 'dart:convert';
import 'dart:io';
import 'package:am_timepunch/postAPI/getAPI.dart';
import 'package:am_timepunch/postAPI/version.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:location/location.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'AccesskeyScreen.dart';
import 'Connectivity/ReUseConnectivity.dart';
import 'DeviceInfo/APKReleaseVersion.dart';
import 'Dialogboxes/ConfirmationPopup.dart';
import 'LocalStorage/MySharedPref.dart';
import 'listen_location.dart';
import 'package:http/http.dart' as http;

int? initScreen = 0;

Future<void> main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  MySharedPreferences.instance.setIntValue("initScreen", 1);
  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TimePunch',
      theme: ThemeData.dark(
          // primarySwatch:Colors.blue,
          ),
      home: const MyHomePage(title: 'TimePunch'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Location location = Location();
  late String emplloyeecode;
  late List<Versionitem> versionList;
  late String android_VersionNumber;
  late int ios_VersionNumber;
  late String BuildNumber;

  @override
  void initState() {
    super.initState();
    getApi().getVersionitem(context).then((users) {
      setState(() {
        versionList = users!;
        if (versionList.length == 0) {
        } else {
          getAPKBuildNum().then((value) {
            BuildNumber = value;
            if (Platform.isAndroid) {
              android_VersionNumber = versionList.first.apkVersion;
              print('Build android ${BuildNumber}');
              // Android 9 (SDK 28), Xiaomi Redmi Note 7
              if (int.parse(BuildNumber) >= int.parse(android_VersionNumber)) {
                print('Build android ${BuildNumber} / ${android_VersionNumber}');
                InitStateMain();
              } else {
                print('Build123 android ${BuildNumber} / ${android_VersionNumber}');
                ErrorPopup(context);
              }
            }
            if (Platform.isIOS) {
              ios_VersionNumber = versionList.first.iosVersion;
              // iOS 13.1, iPhone 11 Pro Max iPhone
              if (int.parse(BuildNumber) >= ios_VersionNumber) {
                print('Build ios ${BuildNumber}/${ios_VersionNumber}');
                InitStateMain();
              } else {
                print('Build123 ios ${BuildNumber}/${ios_VersionNumber}');
                ErrorPopup(context);
              }
            }
          });
        }
      });
    });
  }

  InitStateMain() {
    MySharedPreferences.instance
        .getIntValue("initScreen")
        .then((code) => setState(() {
              initScreen = code;
              print('initScreen:  ${initScreen}');
              if (initScreen == 0) {
                new Future.delayed(const Duration(seconds: 3), () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => Accesskey()), (Route<dynamic> route) => false);
                });
              }
              else if (initScreen == 1) {
                // MySharedPreferences.instance.setIntValue("initScreen", 2);
                MySharedPreferences.instance
                    .getStringValue("empcode")
                    .then((code) => setState(() {
                          emplloyeecode = code;
                          print('employee code ${emplloyeecode}');
                          if (emplloyeecode == '') {
                            new Future.delayed(const Duration(seconds: 3), () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Accesskey()),
                                  (Route<dynamic> route) => false);
                            });
                          }
                          else {
                            new Future.delayed(const Duration(seconds: 3), () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ListenLocationWidget()),
                                  (Route<dynamic> route) => false);
                            });
                          }
                        }));
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:ReuseOffline().getoffline(

      Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Image.asset('assets/logo_white.png',
                      height: 250, width: 260),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: Column(
                      children: [
                        Text(
                          "Powered by Artistic Milliners",
                          style: TextStyle(
                              // remove this if don't have custom font
                              fontSize: 10.0,
                              // text size
                              color: Colors.white,
                              fontFamily: 'titlefont' // text color
                              ),
                        ),
                        Text(
                          "Copyright © 2021 All Rights Reserved",
                          style: TextStyle(
                              // remove this if don't have custom font
                              fontSize: 10.0,
                              // text size
                              color: Colors.white,
                              fontFamily: 'titlefont' // text color
                              ),
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
      ),)
    );
  }

  ErrorPopup(BuildContext dialogContext) {
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
        title: 'Update App?',
        desc:
            'A new version of Time Punch available. Would You like to update it now?',
        buttons: [
          DialogButton(
            child: Text(
              'Update',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              LaunchReview.launch(
                androidAppId: "am.timepunch",
                iOSAppId: "",
              );
            },
            color: Colors.black,
          ),
        ]).show();
  }
}
