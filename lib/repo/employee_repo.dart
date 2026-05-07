import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/employee_model.dart';
import '../utils/constants.dart';

class EmployeeRepository {
  final String baseUrl = Constants.baseUrl;

  Future<List<Employee>> fetchEmployees() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/employees'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Employee.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load employees: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Employee> addEmployee(Employee employee) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/employees'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(employee.toJson()),
      );

      if (response.statusCode == 201) {
        return Employee.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add employee');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}