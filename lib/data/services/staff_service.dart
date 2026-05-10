import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:packare_manage_web/data/services/user_service.dart';

import '../../.const.dart';

class StaffService {
  Future<Map<String, dynamic>> fetchAllUsers(String token,
      {int? limit, int? page}) async {
    final url = Uri.parse(
        '$baseUri/staff/users?limit=${limit ?? 10}&page=${page ?? 1}');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> fetchUsersByRole(String token, String role,
      {int? limit, int? page}) async {
    final url = Uri.parse(
        '$baseUri/staff/users/role/$role?limit=${limit ?? 10}&page=${page ?? 1}');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> fetchOrdersByStatus(String token, String status,
      {int? limit, int? page}) async {
    final url = Uri.parse(
        '$baseUri/staff/orders/status/$status?limit=${limit ?? 10}&page=${page ?? 1}');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> fetchAllOrders(String token,
      {int? limit, int? page}) async {
    final url = Uri.parse(
        '$baseUri/staff/orders?limit=${limit ?? 10}&page=${page ?? 1}');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    final Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else if (response.statusCode == 404) {
      throw UserProfileNotFoundException(data['message'] ?? 'User not found');
    } else if (response.statusCode == 400) {
      throw PasswordChangeFailedException(data['message'] ?? 'Bad request');
    } else {
      throw Exception(
          'Request failed with status: ${response.statusCode}. Response: ${response.body}');
    }
  }
}
