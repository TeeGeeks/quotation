import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import './base_url.dart';
import 'dart:convert';

import './quotations.dart';
import './widgets/main_drawer.dart';
import './widgets/user_profile.dart'; // Import your Quotation model

class DeleteScreen extends StatefulWidget {
  @override
  _DeleteScreenState createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen> {
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

  Future<void> deleteQuotation(String id) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token;

    final response = await http.delete(
      Uri.parse(getBaseUrl("quotations/$id")),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        _quotations = fetchQuotations();
      });
    } else {
      throw Exception('Failed to delete quotation');
    }
  }

  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Delete Quotations'),
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
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline, size: 48.0, color: Colors.grey),
                      SizedBox(height: 16.0),
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
                    return Dismissible(
                      key: Key(quotation.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.delete, color: Colors.white),
                            Text(
                              'Swipe left to delete',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Delete Quotation'),
                              content: const Text(
                                  'Are you sure you want to delete this quotation?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    deleteQuotation(quotation.id as String);
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) {
                        deleteQuotation(quotation.id as String);
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        child: ListTile(
                          title: Text(
                              '${quotation.productName}: ${quotation.productTitle}'),
                          subtitle: Text(
                              'Quantity: ${quotation.numberOfCopies}: ${quotation.date != null ? dateFormat.format(quotation.date) : ''}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Quotation'),
                                  content: const Text(
                                      'Are you sure you want to delete this quotation?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteQuotation(
                                            quotation.id.toString());
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
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
