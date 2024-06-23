import 'dart:convert';
import 'package:http/http.dart' as http;
import './base_url.dart';

class AuthService {
  static Future<bool> isTokenExpired(String token) async {
    try {
      // Make a request to validate the token
      final response = await http.get(
        Uri.parse(getBaseUrl('validate_token')),
        headers: {'Authorization': 'Bearer $token'},
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Token is valid, parse the response body
        final responseData = jsonDecode(response.body);
        // Extract the expiry date from the response data (this depends on your authentication service)
        final expiryDate = DateTime.parse(responseData['expiry_date']);

        // Check if the token is expired by comparing the expiry date with the current date
        final currentDate = DateTime.now();
        if (expiryDate.isAfter(currentDate)) {
          // Token is not expired
          return false;
        } else {
          // Token is expired
          return true;
        }
      } else {
        // Token validation failed, token might be expired
        return true;
      }
    } catch (e) {
      // An error occurred during token validation, consider token expired
      return true;
    }
  }
}
