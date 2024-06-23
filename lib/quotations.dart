import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import './base_url.dart';
import './get_price.dart';
import './get_user.dart';
import './widgets/main_drawer.dart';
import './widgets/user_profile.dart';
import 'dart:convert';
import './screen/quotation_details_screen.dart';

class Quotation {
  final int id;
  final int userId;
  final String productName;
  final String productTitle;
  final String sizeOfPaper;
  final String paperColor;
  final int grammageForPaper;
  final int numberOfCopies;
  final String numberOfCover;
  final int grammageOfCard;
  final String sizeOfCard;
  final int designCost;
  final int plateMakingCost;
  final int? runningCost;
  final String noOfColorsText;
  final int numberOfPages;
  final List<String> finishingCosts;
  final int? editingCost;
  final int impressionCost;
  final String address;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  Quotation({
    required this.id,
    required this.userId,
    required this.productName,
    required this.productTitle,
    required this.sizeOfPaper,
    required this.paperColor,
    required this.grammageForPaper,
    required this.numberOfCopies,
    required this.numberOfCover,
    required this.grammageOfCard,
    required this.sizeOfCard,
    required this.designCost,
    required this.plateMakingCost,
    this.runningCost,
    required this.noOfColorsText,
    required this.numberOfPages,
    required this.finishingCosts,
    this.editingCost,
    required this.impressionCost,
    required this.address,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Quotation.fromJson(Map<String, dynamic> json) {
    return Quotation(
      id: json['id'],
      userId: json['userId'],
      productName: json['productName'],
      productTitle: json['productTitle'],
      sizeOfPaper: json['sizeOfPaper'],
      paperColor: json['paperColor'],
      grammageForPaper: json['grammageForPaper'],
      numberOfCopies: json['numberOfCopies'],
      numberOfCover: json['numberOfCover'],
      grammageOfCard: json['grammageOfCard'],
      sizeOfCard: json['sizeOfCard'],
      designCost: json['designCost'],
      plateMakingCost: json['plateMakingCost'],
      runningCost: json['runningCost'],
      noOfColorsText: json['noOfColorsText'],
      numberOfPages: json['numberOfPages'],
      finishingCosts: List<String>.from(json['finishingCosts']),
      editingCost: json['editingCost'],
      impressionCost: json['impressionCost'],
      address: json['address'],
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'productName': productName,
      'productTitle': productTitle,
      'sizeOfPaper': sizeOfPaper,
      'paperColor': paperColor,
      'grammageForPaper': grammageForPaper,
      'numberOfCopies': numberOfCopies,
      'numberOfCover': numberOfCover,
      'grammageOfCard': grammageOfCard,
      'sizeOfCard': sizeOfCard,
      'designCost': designCost,
      'plateMakingCost': plateMakingCost,
      'runningCost': runningCost,
      'noOfColorsText': noOfColorsText,
      'numberOfPages': numberOfPages,
      'finishingCosts': finishingCosts,
      'editingCost': editingCost,
      'impressionCost': impressionCost,
      'address': address,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class AllQuotationScreen extends StatefulWidget {
<<<<<<< HEAD
  const AllQuotationScreen({super.key});

=======
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
  @override
  _AllQuotationScreenState createState() => _AllQuotationScreenState();
}

class _AllQuotationScreenState extends State<AllQuotationScreen> {
  late Future<List<Quotation>> _quotations;
  late Future<List<Price>> _prices;
  User? _user;
  String? _userLogo;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    _quotations = fetchQuotations(context);
    _prices = PriceService.fetchPrices(context);
    _fetchUser();
  }

  Future<List<Quotation>> fetchQuotations(BuildContext context) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;

      final response = await http.get(
        Uri.parse(getBaseUrl('quotations')),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Quotation> userQuotations =
            data.map((json) => Quotation.fromJson(json)).where((quotation) {
          print('Quotation userId: ${quotation.userId}');
          print(
              'UserProvider userId: ${int.tryParse(userProvider.userId ?? '')}');
          return quotation.userId == int.tryParse(userProvider.userId ?? '');
        }).toList();
        print(userQuotations);
        return userQuotations;
      } else {
        print(
            'Failed to fetch quotations. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
            'Failed to fetch quotations. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to fetch quotations: $error');
      throw Exception('Failed to fetch quotations: $error');
    }
  }

  Future<void> _fetchUser() async {
    try {
      String? userId = Provider.of<UserProvider>(context, listen: false).userId;
      String? token = Provider.of<UserProvider>(context, listen: false).token;
      User? user = await UserApi.getUser(userId!, token!); // Fetch user details
      if (user != null && user.logo.isNotEmpty) {
        setState(() {
          _user = user;
          _userLogo = getBaseUrl(user.logo)
              .replaceAll('\\', '/'); // Ensure URL uses forward slashes
        });
        print('User logo URL: $_userLogo');
      }
    } catch (error) {
      print('Error fetching user logo: $error');
    }
  }

  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        title: const Text('All Quotations'),
      ),
      drawer: const MainDrawer(),
=======
        title: Text('All Quotations'),
      ),
      drawer: MainDrawer(),
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
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
<<<<<<< HEAD
              return const Center(child: CircularProgressIndicator());
=======
              return Center(child: CircularProgressIndicator());
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
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
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Column(
                        children: [
                          const Text(
                            'Check Quotation',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Date: ${quotation.date != null ? dateFormat.format(quotation.date) : ''}',
                          )
                        ],
                      ),
                      title: Text(
                        '${quotation.productName}: ${quotation.productTitle}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            'Quantity: ${quotation.numberOfCopies.toString()}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FutureBuilder<List<Price>>(
                              future: _prices,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
<<<<<<< HEAD
                                  return const Center(
=======
                                  return Center(
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else {
                                  return QuotationDetailsScreen(
                                    quotationData: {
                                      'Product Name': quotation.productName,
                                      'Product Title': quotation.productTitle,
                                      'Size of Paper': quotation.sizeOfPaper,
                                      'Paper Color': quotation.paperColor,
                                      'Number of Copies':
                                          quotation.numberOfCopies,
                                      'Color(s) of Text':
                                          quotation.noOfColorsText,
                                      'Color(s) of Cover':
                                          quotation.numberOfCover,
                                      'Number of Pages':
                                          quotation.numberOfPages,
                                      'Grammage of Paper':
                                          quotation.grammageForPaper,
                                      'Grammage of Card':
                                          quotation.grammageOfCard,
                                      'Size of Card': quotation.sizeOfCard,
                                      'Finishing': quotation.finishingCosts
<<<<<<< HEAD
                                              .join(', ') ??
=======
                                              ?.join(', ') ??
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
                                          '',
                                      'Graphics Design Cost (₦)':
                                          quotation.designCost,
                                      'Plate Making Cost (₦)':
                                          quotation.plateMakingCost,
                                      'Running Cost (Offset) (₦)':
                                          quotation.runningCost,
                                      'Editing Cost (₦)': quotation.editingCost,
                                      'Impression Cost (₦)':
                                          quotation.impressionCost,
                                      'Address': quotation.address,
                                      'Date': quotation.date != null
<<<<<<< HEAD
                                          ? quotation.date.toString()
=======
                                          ? quotation.date!.toString()
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
                                          : '',
                                    },
                                    prices: snapshot.data ?? [],
                                    user: _user, // Pass user information
                                    userLogo: _userLogo, // Pass user logo URL
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        )
      ]),
    );
  }
}
