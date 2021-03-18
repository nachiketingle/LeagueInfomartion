import 'package:http/http.dart' as http;
import '../Helpers/Constants.dart';
class Network with Constants{

  /// REST API get request
  static Future<dynamic> get(String type, Map<String, String>? queries) async {
    Map<String, String> headers = Map();
    headers['Content-Type'] = 'application/json';
    if(queries == null)
      queries = Map();
    queries['api_key'] = Constants.API_KEY;
    String path = type;//+ convertQueryToString(queries);
    print(path);
    Uri uri = Uri.https(Constants.baseURL, path, queries);
    print(uri.toString());
    var response = await http.get(uri, headers: headers);
    printResponse('GET', response.body, response.statusCode.toString());
    return response.body;
  }

  /// REST API get request from DDragon
  static Future<dynamic> getDDragon(String type, String query, {bool patch: true}) async {
    Map<String, String> headers = Map();
    headers['Content-Type'] = 'application/json';
    if(query == null)
      return null;
    String path = (patch ? Constants.patch : "") + type + query;
    Uri uri = Uri.https(Constants.ddragonHost, path);
    print(uri.toString());
    var response = await http.get(uri, headers: headers);
    printResponse('GET', response.body, response.statusCode.toString());
    return response.body;
  }

  static String convertQueryToString(Map<String, String> queries) {
    if(queries.length == 0)
      return "";

    String finalQuery = "?";

    int count = 0;
    queries.forEach((key, value) {
      finalQuery += "$key=$value";
      if(count < queries.length - 1)
        finalQuery += "&";
      count++;
    });

    return finalQuery;
  }

  static void printResponse(String apiType, String response, String statusCode) {
    print("$apiType: $response");
  }
}