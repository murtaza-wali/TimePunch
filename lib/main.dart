
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AccesskeyScreen.dart';
import 'LocalStorage/MySharedPref.dart';
import 'listen_location.dart';

int? initScreen = 0;

Future<void> main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = (await prefs.getInt("initScreen"));
  await prefs.setInt("initScreen", 1);
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

  @override
  void initState() {
    super.initState();

    if (initScreen == null) {
      new Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => Accesskey()),
            (Route<dynamic> route) => false);
      });
    } else if (initScreen == 1) {
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
                            builder: (BuildContext context) => Accesskey()),
                        (Route<dynamic> route) => false);
                  });
                } else {
                  new Future.delayed(const Duration(seconds: 3), () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ListenLocationWidget()),
                            (Route<dynamic> route) => false);
                  });
                }
              }));
      /*  print('employee code ${emplloyeecode}');
      new Future.delayed(const Duration(seconds: 3), () {
        //
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ListenLocationWidget()),
                (Route<dynamic> route) => false);
      });*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
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
      ),
    );
  }
}
