import 'dart:convert';

import 'package:http/http.dart' as http;

class GeminiApi {
  final String apiKey;
  final String apiUrl;

  GeminiApi({required this.apiKey, required this.apiUrl});

  Future<void> sendRequest() async {
    final url =
        Uri.parse('$apiUrl/your-endpoint'); // Doğru endpoint'i buraya girin
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        // Göndermek istediğiniz veri burada
        'key1': 'value1',
        'key2': 'value2',
      }),
    );

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
}
