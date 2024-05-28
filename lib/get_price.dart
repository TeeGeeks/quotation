import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:quotation_app/base_url.dart';
import 'package:quotation_app/widgets/user_profile.dart';

class PriceService {
  static Future<List<Price>> fetchPrices(BuildContext context) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;

      final response = await http.get(
        Uri.parse(getBaseUrl("get_prices")),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<Price> prices = data.map((json) => Price.fromJson(json)).toList();
        return prices;
      } else {
        throw Exception('Failed to fetch prices: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch prices: $e');
    }
  }
}

class Price {
  String name;
  String label;
  double price;

  Price({required this.name, required this.label, required this.price});

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      name: json['name'],
      label: json['label'],
      price: json['price'].toDouble(),
    );
  }

  @override
  String toString() {
    return 'Price{name: $name, label: $label, price: $price}';
  }
}
