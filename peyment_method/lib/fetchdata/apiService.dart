import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://api.aviapages.com/v3";
  final String apiKey = "qDF50oNmO7E9wN574h5HibHRkKW1recwW8R9";

  Map<String, String> get headers => {
        "Authorization": "Token $apiKey",
        "Accept": "application/json",
      };

  // Aircraft list
  Future<List<dynamic>> getCharterAircraftRaw() async {
    final response = await http.get(
      Uri.parse("$baseUrl/charter_aircraft/"),
      headers: headers,
    );

    print("LIST STATUS: ${response.statusCode}");
    print("LIST BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Failed to load aircraft list");
    }

    final data = jsonDecode(response.body);
    return data['results'];
  }

  // Aircraft details
  Future<Map<String, dynamic>> getAircraftDetailsRaw(int id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/charter_aircraft/$id/"),
      headers: headers,
    );

    print("DETAIL STATUS: ${response.statusCode}");
    print("DETAIL BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Failed to load aircraft details");
    }

    return jsonDecode(response.body);
  }
}

