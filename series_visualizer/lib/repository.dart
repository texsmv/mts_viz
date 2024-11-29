import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<Map<String, dynamic>> loadFromPath(String path) async {
    final response = await http.post(
      Uri.parse('$baseUrl/loadFromPath'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'path': path}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load from path');
    }
  }

  Future<List<String>> getObjectNames() async {
    final response = await http.post(
      Uri.parse('$baseUrl/getObjectNames'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data['object_names']);
    } else {
      throw Exception('Failed to get object names');
    }
  }

  Future<Map<String, dynamic>> getObjectInfo(String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/getObjectInfo'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['object_info'];
    } else {
      throw Exception('Failed to get object info');
    }
  }

  Future<Map<String, List<double>>> getTimeMeanStd(String name, int dim, List<int> positions) async {
    final response = await http.post(
      Uri.parse('$baseUrl/getTimeMeanStd'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'dim': dim,
        'positions': positions,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'mean': List<double>.from(data['mean']),
        'std': List<double>.from(data['std']),
      };
    } else {
      throw Exception('Failed to get time mean and std');
    }
  }
}