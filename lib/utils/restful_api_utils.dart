import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RestfulApiUtils {
  //Singleton realization
  static final RestfulApiUtils _instance = RestfulApiUtils.internal();
  RestfulApiUtils.internal();
  factory RestfulApiUtils() => _instance;

  Future<dynamic> get(String url, Map<String, String> headers) async {
    final response = await http.get(url, headers: headers);
    _checkStatusCode(response.statusCode, response.headers.toString());
    return json.decode(response.body);
  }

  Future<dynamic> post(String url, {Map headers, body, encoding}) {
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      _checkStatusCode(response.statusCode, response.headers.toString());
      return json.decode(response.body);
    });
  }

  void _checkStatusCode(int statusCode, String headers){
    if (statusCode < 200 || statusCode > 400 || json == null) {
      print(headers);
      throw new Exception("Error while fetching data");
    }
  }
}