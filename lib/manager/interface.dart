import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getLocation(double latitude, double longitude) async {
  final uri =
      "https://easytaxinepal.com/nominatim/reverse?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1";
  http.Response response = await http.get(
    Uri.parse(uri),
    headers: <String, String>{},
  );
  final responseData = await json.decode(response.body);
  return responseData['display_name'].toString();
}
