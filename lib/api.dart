import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<AmLocation> fetchLocation() async {
  final response = await http
      // .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
      .get(Uri.parse('https://apps.artisticmilliners.com:8085/ords/app/geo/location/24.83877/67.13705'));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return AmLocation.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Location');
  }
}

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

void main() => runApp(const ApiWidget());

class ApiWidget extends StatefulWidget {
  const ApiWidget({Key? key}) : super(key: key);

  @override
  _ApiWidget createState() => _ApiWidget();
}

class _ApiWidget extends State<ApiWidget> {
  late Future<AmLocation> futureAmLocation;

  @override
  void initState() {
    super.initState();
    futureAmLocation = fetchLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<AmLocation>(
            future: futureAmLocation,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.locName);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}