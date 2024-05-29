import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quotation_app/base_url.dart';
import 'package:quotation_app/get_price.dart';
import 'package:quotation_app/get_user.dart';
import 'package:quotation_app/widgets/main_drawer.dart';
import 'package:quotation_app/widgets/user_profile.dart';
import 'dart:convert';
import './screen/quotation_details_screen.dart';

class Quotation {
  String? id;
  String? productName;
  String? productTitle;
  String? sizeOfPaper;
  String? paperColor;
  int? grammageForPaper;
  int? numberOfCopies;
  String? numberOfCover;
  int? grammageOfCard;
  String? sizeOfCard;
  int? designCost;
  int? plateMakingCost;
  int? runningCost;
  int? editingCost;
  int? impressionCost;
  String? noOfColorsText;
  int? numberOfPages;
  List<String>? finishingCosts;
  String? address;
  DateTime? date;
  String? createdByUserId;

  Quotation(
      {required this.id,
      this.productName,
      this.productTitle,
      this.sizeOfPaper,
      this.paperColor,
      this.grammageForPaper,
      this.numberOfCopies,
      this.numberOfCover,
      this.grammageOfCard,
      this.sizeOfCard,
      this.designCost,
      this.plateMakingCost,
      this.runningCost,
      this.noOfColorsText,
      this.numberOfPages,
      this.finishingCosts,
      this.address,
      this.date,
      this.createdByUserId,
      this.editingCost,
      this.impressionCost});

  factory Quotation.fromJson(Map<String, dynamic> json) {
    return Quotation(
      id: json['_id'] ?? '',
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
      editingCost: json['editingCost'],
      impressionCost: json['impressionCost'],
      noOfColorsText: json['noOfColorsText'],
      numberOfPages: json['numberOfPages'],
      finishingCosts: json['finishingCosts'] != null
          ? List<String>.from(json['finishingCosts'])
          : null,
      address: json['address'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      createdByUserId: json['userId'],
    );
  }

  // Object? toJson() {}
}

class AllQuotationScreen extends StatefulWidget {
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
    _quotations = fetchQuotations();
    _prices = PriceService.fetchPrices(context);
    _fetchUser();
  }

  Future<List<Quotation>> fetchQuotations() async {
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
        final List<Quotation> userQuotations = data
            .map((json) => Quotation.fromJson(json))
            .where(
                (quotation) => quotation.createdByUserId == userProvider.userId)
            .toList();
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
      User? user = await UserApi.getUser(userId!); // Fetch user details
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
        title: Text('All Quotations'),
      ),
      drawer: MainDrawer(),
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
              return Center(child: CircularProgressIndicator());
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
                          Text(
                            'Check Quotation',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Date: ${quotation.date != null ? dateFormat.format(quotation.date!) : ''}',
                          )
                        ],
                      ),
                      title: Text(
                        '${quotation.productName ?? ''}: ${quotation.productTitle ?? ''}',
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
                                  return Center(
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
                                              ?.join(', ') ??
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
                                          ? quotation.date!.toString()
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
