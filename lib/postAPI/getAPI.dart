import 'package:am_timepunch/postAPI/postapi.dart';
import 'package:http/http.dart' as http;

class getApi {
  Future<http.Response?> getAttendancePerfomance(String key) async {
    //network request
    // parse URI .....
    var employeeImageURL =
        Uri.parse(BaseURL().Auth + "timepunch/validate/" + key.toString());
    print('Result${employeeImageURL}');
    final result = await http.get(employeeImageURL);
    if (result.statusCode == 200) {
      print('Result${result.body}');
      return result;
    }
  }
}
