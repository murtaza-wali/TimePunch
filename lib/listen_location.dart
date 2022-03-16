import 'dart:async';
import 'dart:convert';
import 'package:am_timepunch/main.dart';
import 'package:am_timepunch/postAPI/currenttime_class.dart';
import 'package:am_timepunch/postAPI/getAPI.dart';
import 'package:am_timepunch/postAPI/getlogsApi.dart';
import 'package:am_timepunch/postAPI/postapi.dart';
import 'package:am_timepunch/postAPI/validate_class.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:restart_app/restart_app.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'Connectivity/ReUseConnectivity.dart';
import 'DeviceInfo/APKReleaseVersion.dart';
import 'Dialogboxes/ConfirmationPopup.dart';
import 'LocalStorage/MySharedPref.dart';
import 'package:safe_device/safe_device.dart';

bool checked = false;
bool canMockLocation = false;
var postChecked = false;

var locLat = _ListenLocationState()._location?.latitude;
var locLong = _ListenLocationState()._location?.longitude;

String am_location = 'Verifying Location';

Future<http.Response> fetchLocation() async {
  final response = Uri.parse(
      'https://apps.artisticmilliners.com:8085/ords/app/geo/location/' +
          '${locLat}' +
          '/' +
          '${locLong}');
  print('response: ${response}');
  var deviceresult = await http.get(response);

  if (deviceresult.statusCode == 200) {
    checked = true;
    return deviceresult;
  } else {
    checked = false;
    am_location = 'Location not identified';
  }
  checked = false;
  return deviceresult;
}

/*
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
  checked = false;
  return attendanceResult;
}
*/
class AmLocation {
  final int locId;
  final String locName;

  AmLocation({
    required this.locId,
    required this.locName,
  });

  factory AmLocation.fromJson(Map<String, dynamic> json) {
    return AmLocation(
      locId: json['loc_id'],
      locName: json['location_name'],
    );
  }
}

class ListenLocationWidget extends StatefulWidget {
  const ListenLocationWidget({Key? key}) : super(key: key);

  @override
  _ListenLocationState createState() => _ListenLocationState();
}

class _ListenLocationState extends State<ListenLocationWidget>
    with WidgetsBindingObserver {
  final Location location = Location();
  List<Logsitem> loglist = [];

  // String am_location = '';
  late String emplloyeecode;
  late String emplloyeename, akey, isactive;
  int? initScreen;
  List<CurrentTimeitem> timeList = [];
  late String currenttime = 'Loading...';
  late String ip;

  loadTime() async {
    getApi().getCurrentTime(context).then((users) {
      setState(() {
        timeList = users!;
        if (timeList.length == 0) {
        } else {
          currenttime = timeList.first.time;
        }
      });
    });
  }

  late String BuildNumber;

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 5), (_) => loadTime());
    MySharedPreferences.instance.getIntValue("initScreen").then((code) =>
        setState(() {
          initScreen = code;
          print('initScreen:  ${initScreen}');
          if (initScreen == 0) {
            _listenLocation().then((value) {
              print('value is ${canMockLocation}');
              if (canMockLocation) {
                RelaunchconfirmationPopup(
                    context,
                    "Alert !",
                    ' . Please disable any fake location application before accessing TIME PUNCH.\n '
                        'Relaunch the APP after pressing OK button.',
                    'OK');
              }
            });
          } else {
            MySharedPreferences.instance
                .getStringValue("akey")
                .then((name) => setState(() {
                      akey = name;
                      print('employee akey ${akey}');
                      getAPKBuildNum().then((value) {
                        BuildNumber = value;
                        print('aBuildNumberkey ${BuildNumber}');
                        postJSON()
                            .postversion_chk(context, akey, BuildNumber)
                            .then((value) {});
                      });
                      getApi().getLogs(context, akey).then((value) {
                        loglist = value!;
                      });
                      getApi().getvalidate(context, akey).then((value) {
                        list = value!;
                        isactive = list[0].isactive;
                        if (isactive == "N") {
                          MySharedPreferences.instance.removeAll();
                          confirmationPopup(
                              context,
                              "Alert !",
                              '. Your Access Key is revoked . \n Please contact Administrator to validate your Access Key',
                              'OK',
                              emplloyeename);
                        } else if (isactive == null) {
                          MySharedPreferences.instance.removeAll();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => MyApp()),
                              (Route<dynamic> route) => false);
                        } else if (isactive == "Y") {
                          MySharedPreferences.instance
                              .getIntValue("initScreen")
                              .then((code) => setState(() {
                                    initScreen = code;
                                    print('initScreen:  ${initScreen}');
                                    if (initScreen == 0) {
                                      _listenLocation().then((value) {
                                        print('value is ${canMockLocation}');
                                        if (canMockLocation) {
                                          RelaunchconfirmationPopup(
                                              context,
                                              "Alert !",
                                              ' . Please disable any fake location application before accessing TIME PUNCH.\n '
                                                  'Relaunch the APP after pressing OK button.',
                                              'OK');
                                        }
                                      });
                                    } else {
                                      _listenLocation().then((value) {
                                        print('value is ${canMockLocation}');
                                        if (canMockLocation) {
                                          confirmationPopup(
                                              context,
                                              "Alert !",
                                              '. We have detected Fake Location application is enabled. \n'
                                                  'You cannot proceed until it is disabled.',
                                              'OK',
                                              emplloyeename);
                                        }
                                      });
                                    }
                                  }));
                          /*_listenLocation().then((value) {
                                print('value is ${canMockLocation}');
                                if (canMockLocation) {
                                  confirmationPopup(
                                      context,
                                      "Alert !",
                                      '. We have detected Fake Location application is enabled. \n'
                                          'You cannot proceed until it is disabled.',
                                      'OK');
                                }
                              });*/
                        }
                      });
                    }));
          }
        }));

    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    MySharedPreferences.instance
        .getStringValue("empcode")
        .then((code) => setState(() {
              emplloyeecode = code;
              print('employee code ${emplloyeecode}');
            }));
    MySharedPreferences.instance
        .getStringValue("emp_name")
        .then((name) => setState(() {
              emplloyeename = name;
              print('employee emp_name ${emplloyeecode}');
            }));
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.inactive:
        onPaused();
        break;
      case AppLifecycleState.paused:
        onInactive();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
    }
  }

  late List<Item> list;

  void onResumed() {
    print('onResumed');
    Restart.restartApp();
    /*initState();*/

    /*   getApi().getvalidate(context, akey).then((value) {
      list = value!;
      isactive = list[0].isactive;
      if (isactive == "N") {
        MySharedPreferences.instance.removeAll();
        confirmationPopup(
            context,
            "Alert !",
            '. Your Access Key is revoked . \n Please contact Administrator to validate your Access Key',
            'OK',
            emplloyeename);
      } else if (isactive == null) {
        MySharedPreferences.instance.removeAll();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => MyApp()),
            (Route<dynamic> route) => false);
      } else if (isactive == "Y") {
        MySharedPreferences.instance
            .getIntValue("initScreen")
            .then((code) => setState(() {
                  initScreen = code;
                  print('initScreen:  ${initScreen}');
                  if (initScreen == 0) {
                    _listenLocation().then((value) {
                      print('value is ${canMockLocation}');
                      if (canMockLocation) {
                        RelaunchconfirmationPopup(
                            context,
                            "Alert !",
                            ' . Please disable any fake location application before accessing TIME PUNCH.\n '
                                'Relaunch the APP after pressing OK button.',
                            'OK');
                      }
                    });
                  } else {
                    _listenLocation().then((value) {
                      print('value is ${canMockLocation}');
                      if (canMockLocation) {
                        confirmationPopup(
                            context,
                            "Alert !",
                            '. We have detected Fake Location application is enabled. \n'
                                'You cannot proceed until it is disabled.',
                            'OK',
                            emplloyeename);
                      }
                    });
                  }
                }));
      }
    });*/
  }

  void onPaused() {
    print('onPaused');
  }

  void onInactive() {
    print('onInactive');
  }

  void onDetached() {
    print('onDetached');
  }

  late int org_id;
  LocationData? _location;
  StreamSubscription<LocationData>? _locationSubscription;
  String? _error;
  List<AmLocation> amLocation = [];

  Future<void> _listenLocation() async {
    //_stopListen();
    // print('${_stopListen()}');
    if (!mounted) return;
    try {
      canMockLocation = await SafeDevice.canMockLocation;
    } catch (error) {
      print(error);
    }
    setState(() {
      // _stopListen();
      canMockLocation = canMockLocation;
      _locationSubscription = null;
      locLat = null;
      locLong = null;
      checked = false;
      am_location = 'Verifying Location';
    });
    _locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
      if (err is PlatformException) {
        setState(() {
          _error = err.code;
        });
      }
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((LocationData currentLocation) {
      setState(() {
        _error = null;
        _location = currentLocation;
        locLat = _location?.latitude;
        locLong = _location?.longitude;
        fetchLocation().then((loc) {
          Map<String, dynamic> fetchLocation = jsonDecode(loc.body);
          am_location = 'Welcome to ' + fetchLocation['location_name'];
          org_id = fetchLocation['org_id'];
        });
        // print('Location name${am_location}');
        print('Loc Lat: ${locLat}' + 'Loc Long: ${locLat}');
        print('response: ${fetchLocation()}');
      });
    });
    setState(() {});
  }

  Future<void> _stopListen() async {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
      locLat = null;
      locLong = null;
      checked = false;
      am_location = 'Location not identified';
    });
  }

  @override
  void dispose() {
    print('check');
    WidgetsBinding.instance!.removeObserver(this);
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/logo_white.png',
                fit: BoxFit.cover,
                height: 30,
              ),
              CustomElevation(
                height: 35,
                child: FlatButton(
                  shape: StadiumBorder(),
                  color: Colors.black,
                  onPressed: () {
                    getApi().getLogs(context, akey).then((value) {
                      loglist = value!;
                      loglist.length==0?Container():Navigator.of(context).push(
                        PageRouteBuilder(
                            pageBuilder: (context, _, __) =>
                                customAler(loglist, context,emplloyeename),
                            opaque: false),
                      );
                    });

                  },
                  child: Text('Logs'),
                ),
              ),
              Text('${currenttime == null ? 'Loading...' : currenttime}'),
              /* Text('canMockLocation():'),
              SizedBox(
                width: 8,
              ),*/
              /* Text(
                '${canMockLocation ? "Yes" : "No"}',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),*/
            ],
          ),

          // actions: <Widget>[
          //   IconButton(
          //     icon: const Icon(Icons.info_outline),
          //     onPressed: _showInfoDialog,
          //   )63
          // ],
          /*   actions: [
            new Stack(
              alignment: Alignment.centerRight,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh,color: Colors.white,),
                  onPressed: _locationSubscription == null
                      ? startSearch()
                      : stopsearch(),
                )
              ],
            )
          ],*/
        ),
        body: ReuseOffline().getoffline(Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // PermissionStatusWidget(),
              // Divider(height: 32),
              // ServiceEnabledWidget(),
              // Divider(height: 32),
              // GetLocationWidget(),
              // Divider(height: 32),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '$am_location ',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 35),
                  ),
                  Divider(height: 32),
                  Text(
                    ' Latitude: ' +
                        ('${_location?.latitude}') +
                        '\n Longitude : ' +
                        ('${_location?.longitude}'),
                  ),
                  if (checked)
                    GestureDetector(
                        child: Container(
                          width: 160,
                          height: 220,
                          padding: const EdgeInsets.all(0.0),
                          alignment: Alignment.topCenter,
                          margin: const EdgeInsets.only(
                              left: 20.0, top: 80.0, right: 20),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF09E812).withOpacity(0.5),
                                  spreadRadius: 10,
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ],
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.elliptical(200, 250)),
                              image: DecorationImage(
                                  image:
                                      AssetImage("assets/fingerprintneon.png"),
                                  fit: BoxFit.cover)),
                          child: Container(),
                        ),
                        onTap: () {
                          // yahan post api ayegiii...
                          print('Employee code${emplloyeecode}');
                          print('Employee ORG${org_id}');
                          print('Employee akey${akey}');
                          postJSON()
                              .PostemployeeAttendace(
                                  context, emplloyeecode, org_id, "0", akey)
                              .then((value) {
                            print('post : ${value}');
                            confirmationPopup(
                                context,
                                "Thank you",
                                ' your attendance have been marked',
                                'OK',
                                emplloyeename);
                          });

                          /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SuccessWidget()),
                            );*/
                        })
                  else
                    Column(
                      children: [
                        (Text(
                          'Please reach your unit to mark attendance',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5,
                        )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            /*Container(
                          margin: const EdgeInsets.only(right: 42),
                          //    child:
                          //    startSearchButton()
                        ),*/
                            if (_locationSubscription != null)
                              (stopSearchButton()),
                            if (_locationSubscription == null)
                              (startSearchButton()),
                          ],
                        ),
                      ],
                    ),
                ],
              )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: EdgeInsets.all(0),
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
        )));
  }

  stopsearch() {
    _locationSubscription != null ? _stopListen : null;
  }

  startSearch() {
    _locationSubscription == null ? _listenLocation : null;
  }

  Widget stopSearchButton() {
    return ElevatedButton(
      child: const Text('Stop Searching'),
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF09E812),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        textStyle: TextStyle(
            fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onPressed: _locationSubscription != null ? _stopListen : null,
    );
  }

  Widget startSearchButton() {
    return Container(
      child: ElevatedButton(
        child: const Text('Start Searching'),
        style: ElevatedButton.styleFrom(
          primary: Colors.green,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          textStyle: TextStyle(
              fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: _locationSubscription == null ? _listenLocation : null,
      ),
    );
  }

  RelaunchconfirmationPopup(
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
        desc: 'Hi, ' + emplloyeename + msg,
        buttons: [
          DialogButton(
            child: Text(
              okbtn,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              // closeApp();
              Restart.restartApp();
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
}

class CustomElevation extends StatelessWidget {
  final Widget child;
  final double height;

  CustomElevation({required this.child, required this.height})
      : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(this.height / 2)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: height / 5,
            offset: Offset(0, height / 5),
          ),
        ],
      ),
      child: this.child,
    );
  }
}

customAler(List<Logsitem> list, BuildContext context,String emplyename) {
  return AlertDialog(
    insetPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    title: Align(
      alignment: Alignment.center,
      child: Row(
        children: [
          new Expanded(
            child: Text(
              '${emplyename}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.0,
                fontFamily: 'headingfont',
              ),
            ),
          ),
        ],
      ),
    ),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))),
    actions: <Widget>[
      FlatButton(
        child: const Text('CANCEL',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontFamily: 'headingfont',
            )),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
    content: StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Container(
          height: 400,
          child:
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
              sortColumnIndex: 0,
              dividerThickness: 2,
              headingTextStyle: TextStyle(
                  color: Colors.white, fontFamily: 'headerfont', fontSize: 15),
              showCheckboxColumn: false,
              dataRowHeight: 60,
              headingRowColor:
              MaterialStateColor.resolveWith((states) => Colors.grey),
              headingRowHeight: 40,
              horizontalMargin: 10,
              columns: <DataColumn>[
                DataColumn(
                  label: Text(
                    'Location',
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Access Time',
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
              ],
              rows: List.generate(
                  list.length,
                      (index) => DataRow(cells: [
                    DataCell(
                      Text('${list[index].orgCode}',
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'headerfont',
                              fontSize: 15)),
                    ),
                    DataCell(Text('${list[index].accessTime}',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        softWrap: false,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'headerfont',
                            fontSize: 15))),
                  ]))),
        ),);
      },
    ),
  );
}
