import 'package:http/http.dart' as http;
import '../Helpers/Constants.dart';
class Network with Constants{


  static Future<dynamic> get(String type, Map<String, String> queries) async {
    Map<String, String> headers = Map();
    headers['Content-Type'] = 'application/json';
    if(queries == null)
      queries = Map();
    queries['api_key'] = Constants.API_KEY;
    String url = Constants.baseURL + type + convertQueryToString(queries);
    print(url);
    var response = await http.get(url, headers: headers);
    printResponse('GET', response.body, response.statusCode.toString());
    return response.body;
  }

  static Future<dynamic> getDDragon(String type, String query) async {
    Map<String, String> headers = Map();
    headers['Content-Type'] = 'application/json';
    if(query == null)
      return null;
    String url = Constants.ddragonURL + type + query;
    print(url);
    var response = await http.get(url, headers: headers);
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