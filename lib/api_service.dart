import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // static const String baseUrl = 'http://10.0.2.2:3000'; // ANDROID
  static const String baseUrl = 'http://localhost:3000';

  // GET Request with query parameters
  static Future<dynamic> get(
    String endpoint,
    Map<String, dynamic>? map, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      // Create URI with query parameters
      final uri = Uri.parse('$baseUrl/$endpoint').replace(
        queryParameters: queryParams?.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          // Add any additional headers here
          // 'Authorization': 'Bearer $token',
        },
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform GET request: $e');
    }
  }

  // POST Request with FormData
  static Future<dynamic> post(
      String endpoint, Map<String, dynamic> body) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/$endpoint'));

      // Add form fields from the body map
      body.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform POST request: $e');
    }
  }

  // PUT Request
  static Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          // Add any additional headers here
          // 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform PUT request: $e');
    }
  }

  // DELETE Request
  static Future<dynamic> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          // Add any additional headers here
          // 'Authorization': 'Bearer $token',
        },
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform DELETE request: $e');
    }
  }

  // Handle API Response
  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('HTTP Error: ${response.statusCode}\n${response.body}');
    }
  }
}
