import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkHelper {
  NetworkHelper(this.url);
  final String url;

  Future getData() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'error': 'Failed to load weather data. Status code: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {
        'error': 'An error occurred while fetching weather data: $e'
      };
    }
  }
}
