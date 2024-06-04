import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:quotation_app/base_url.dart';
import 'package:quotation_app/quotations.dart';
import 'package:quotation_app/widgets/edit_quotation_form.dart';
import 'package:quotation_app/widgets/main_drawer.dart';
import 'package:quotation_app/widgets/user_profile.dart';

class EditScreen extends StatefulWidget {
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late Future<List<Quotation>> _quotations;

  @override
  void initState() {
    super.initState();
    _quotations = fetchQuotations();
  }

  Future<List<Quotation>> fetchQuotations() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token;

    final response = await http.get(
      Uri.parse(getBaseUrl("quotations")),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Quotation> userQuotations =
          data.map((json) => Quotation.fromJson(json)).where((quotation) {
        return quotation.userId == int.tryParse(userProvider.userId ?? '');
      }).toList();
      return userQuotations;
    } else {
      throw Exception('Failed to fetch quotations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Quotations'),
        ),
        drawer: const MainDrawer(),
        body: Stack(children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.white54
                .withOpacity(0.45), // Adjust the opacity as needed (0.0 - 1.0)
          ),
          FutureBuilder<List<Quotation>>(
            future: _quotations,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline, size: 48.0, color: Colors.grey),
                      const SizedBox(height: 16.0),
                      Text('No quotations available',
                          style: TextStyle(fontSize: 18.0, color: Colors.grey)),
                    ],
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final quotation = snapshot.data![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditQuotationForm(quotation: quotation),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: const Text(
                            'Edit Quotation',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          title: Text(
                            quotation.productName ?? '',
                            style: const TextStyle(fontSize: 18.0),
                          ),
                          subtitle: Text(
                            'Quantity: ${quotation.numberOfCopies.toString()}',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          trailing: const Icon(Icons.edit, color: Colors.blue),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ]));
  }
}
