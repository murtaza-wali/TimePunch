import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'Reuseable_Widgets/success_widget.dart';

bool checked = false;
var postChecked=false;

var locLat = _ListenLocationState()._location?.latitude;
var locLong = _ListenLocationState()._location?.longitude;
var ecode = '0106000280';

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
    am_location='Location not identified';
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

class _ListenLocationState extends State<ListenLocationWidget> {
  final Location location = Location();
  // String am_location = '';

  @override
  void initState() {
    _listenLocation();
    super.initState();
  }

  LocationData? _location;
  StreamSubscription<LocationData>? _locationSubscription;
  String? _error;
  List<AmLocation> amLocation = [];

  Future<void> _listenLocation() async {
    _stopListen();
    // print('${_stopListen()}');
    setState(() {
     // _stopListen();
      _locationSubscription = null;
      locLat = null;
      locLong = null;
      checked=false;
      am_location='Verifying Location';
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
          am_location = 'Welcome to '+ fetchLocation['location_name'];
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
      checked=false;
      am_location='Location not identified';
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$am_location ',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline4,
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
                width: 220,
                height: 300,
                margin: const EdgeInsets.only(left: 50.0, top: 20.0),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.5),
                        spreadRadius: 10,
                        blurRadius: 5,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.elliptical(200, 250)),
                    image: DecorationImage(
                        image: AssetImage("assets/fingerprintneon.png"),
                        fit: BoxFit.cover)),
                child: Container(),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) =>  SuccessWidget()
                ),
                );
              })
        else
          (Text(
            'Please reach your unit to mark attendance',
            style: Theme.of(context).textTheme.headline5,
          )),
        Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 42),
          //    child:
          //    startSearchButton()
            ),
            if ( _locationSubscription != null) (
            stopSearchButton()
            ),
            if ( _locationSubscription == null) (
                startSearchButton()
            ),
          ],
        ),
      ],
    );
  }

  Widget stopSearchButton() {
    return    ElevatedButton(
      child: const Text('Stop Searching'),
      onPressed: _locationSubscription != null ? _stopListen : null,
    );
  }

  Widget startSearchButton() {
    return    ElevatedButton(
      child: const Text('Start Searching'),
      onPressed: _locationSubscription == null ? _listenLocation : null,
    );
  }
}
