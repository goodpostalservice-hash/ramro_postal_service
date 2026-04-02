import 'package:dio/dio.dart';

Future<String> getCurrentLocationName(double latitude, double longitude) async {
  var dio = Dio();
  try {
    final uri =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&result_type=street_address&location_type=ROOFTOP&key=AIzaSyApJbrw1zZAbrJCz4Zrv4K_pZnjSpETvuA";
    print(uri);
    var googleResponse = await dio.get(uri, options: Options(headers: {}));
    // final responseData = await json.decode(googleResponse.data)  ;
    return googleResponse.data['results'][0]['formatted_address'];
  } catch (e) {
    return "Unknown address";
  }
}
