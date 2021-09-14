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
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ListenLocationWidget()),
                      (Route<dynamic> route) => false);
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: <Widget>[
              // PermissionStatusWidget(),
              // Divider(height: 32),
              // ServiceEnabledWidget(),
              // Divider(height: 32),
              // GetLocationWidget(),
              // Divider(height: 32),
              Container(),
              // ListenLocationWidget(),
              // ApiWidget(),
              // Divider(height: 32),
              // ChangeSettings(),
              // Divider(height: 32),
              // EnableInBackgroundWidget(),
              // Divider(height: 32),
              // ChangeNotificationWidget()
            ],
          ),
        ),
      ),
    );
  }
}
