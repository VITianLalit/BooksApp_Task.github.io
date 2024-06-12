import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String url = 'https://api.thenotary.app/lead/getLeads';

  static Future<List<dynamic>> getLeads(String notaryId) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'notaryId': notaryId}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> leads = responseData['leads'];
      return leads;
    } else {
      throw Exception('Failed to load leads');
    }
  }
}
