import 'dart:convert';

import 'package:am_timepunch/postAPI/postapi.dart';
import 'package:am_timepunch/postAPI/validate_class.dart';
import 'package:http/http.dart' as http;

class getApi {


  Future<List<Item>?> getvalidate(String key) async {
    // Uri.parse must when you are passing URL.
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
  }
}
