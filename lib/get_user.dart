import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quotation_app/base_url.dart';
import 'package:http_parser/http_parser.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
}

class User {
  String username;
  String email;
  String companyName;
  String companyAddress;
  String companyWebsite;
  String phone;
  String logo;

  User({
    required this.username,
    required this.email,
    required this.companyName,
    required this.companyAddress,
    required this.companyWebsite,
    required this.phone,
    required this.logo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      companyName: json['companyName'] ?? '',
      companyAddress: json['companyAddress'] ?? '',
      companyWebsite: json['companyWebsite'] ?? '',
      phone: json['phone'] ?? '',
      logo: json['logo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'companyName': companyName,
      'companyAddress': companyAddress,
      'companyWebsite': companyWebsite,
      'phone': phone,
      'logo': logo,
    };
  }
}

class UserApi {
  static Future<User?> getUser(String userId) async {
    final url = Uri.parse(getBaseUrl('users/$userId'));

    try {
      final response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);

        if (jsonBody != null && jsonBody is Map<String, dynamic>) {
          return User.fromJson(jsonBody);
        } else {
          throw Exception('Invalid JSON format');
        }
      } else {
        throw Exception(
            'Failed to load user with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<void> updateUser({
    required String userId,
    required String companyName,
    required String companyAddress,
    String? companyWebsite,
    required String username,
    required String phone,
    required String email,
    required String filePath,
    String? password,
  }) async {
    final url = Uri.parse(getBaseUrl('users/$userId'));

    try {
      var request = http.MultipartRequest('PUT', url)
        ..fields['companyName'] = companyName
        ..fields['companyAddress'] = companyAddress
        ..fields['companyWebsite'] = companyWebsite!
        ..fields['username'] = username
        ..fields['phone'] = phone
        ..fields['email'] = email;

      if (password != null) {
        request.fields['password'] = password;
      }

      if (filePath.isNotEmpty) {
        var file = await http.MultipartFile.fromPath(
          'file', // Change 'logo' to match your server's expected file field name
          filePath,
          contentType: MediaType('image',
              'jpeg'), // Adjust content type based on your requirements
        );

        // Check file type using a regular expression
        if (!RegExp(r'jpeg|jpg|png|gif').hasMatch(filePath.toLowerCase())) {
          throw ApiException('Error: Images Only!');
        }

        request.files.add(file);
      }

      final response = await request.send();

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to update user with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to update user');
    }
  }

  static Future<void> createUser({
    required String companyName,
    required String companyAddress,
    String? companyWebsite,
    required String username,
    required String phone,
    required String email,
    required String password,
    required String filePath,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(getBaseUrl('users')),
      );

      // Add text fields
      request.fields['companyName'] = companyName;
      request.fields['companyAddress'] = companyAddress;
      request.fields['companyWebsite'] = companyWebsite!;
      request.fields['username'] = username;
      request.fields['phone'] = phone;
      request.fields['email'] = email;
      request.fields['password'] = password;

      // Add file
      var file = await http.MultipartFile.fromPath(
        'file',
        filePath,
        contentType: MediaType(
            'image', 'jpeg'), // Adjust content type based on your requirements
      );

      // Check file type using a regular expression
      if (!RegExp(r'jpeg|jpg|png|gif').hasMatch(filePath.toLowerCase())) {
        throw ApiException('Error: Images Only!');
      }

      request.files.add(file);

      var response = await request.send();

      if (response.statusCode == 201) {
        return;
      } else {
        var responseBody = await response.stream.bytesToString();
        var message = jsonDecode(responseBody)['message'];
        throw ApiException(message);
      }
    } catch (error) {
      throw ApiException('Error creating user: $error');
    }
  }
}
