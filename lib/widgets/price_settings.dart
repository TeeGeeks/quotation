import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:quotation_app/base_url.dart';
import 'package:quotation_app/widgets/main_drawer.dart';
import 'package:quotation_app/widgets/user_profile.dart';

class PriceSettings extends StatefulWidget {
  @override
  _PriceSettingsState createState() => _PriceSettingsState();
}

class _PriceSettingsState extends State<PriceSettings> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _finishingCostOptions = [
    'Print Text black',
    'Pix on matt paper',
    'Cover full process',
    'Fold',
    'Collate',
    'Thread sewn/bind',
    'Trim',
    'Deliver',
  ];
  final List<int> _grammagesOfPaper = [50, 55, 60, 70, 75, 80, 90, 110];
  final List<int> _grammagesOfCover = [180, 210, 250, 300, 400];
  final List<Map<String, dynamic>> _printingColor = [
    {'name': '1 color of text', 'label': 'Color(s) of Text'},
    {'name': '2 color of text', 'label': 'Color(s) of Text'},
    {'name': '3 color of text', 'label': 'Color(s) of Text'},
    {'name': '4 color of text', 'label': 'Color(s) of Text'},
    {'name': '5 color of text', 'label': 'Color(s) of Text'},
  ];
  final List<Map<String, dynamic>> _printingColorOfCover = [
    {'name': '1 color of cover', 'label': 'Color(s) of Cover'},
    {'name': '2 color of cover', 'label': 'Color(s) of Cover'},
    {'name': '3 color of cover', 'label': 'Color(s) of Cover'},
    {'name': '4 color of cover', 'label': 'Color(s) of Cover'},
    {'name': '5 color of cover', 'label': 'Color(s) of Cover'},
  ];

  late List<TextEditingController> _controllers;
  bool _isLoading = false;
  late ScaffoldMessengerState? _scaffoldMessengerState;

  void populateFormFields(BuildContext context) async {
    try {
      var url = Uri.parse(getBaseUrl("get_prices"));
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.token;

      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data is List) {
          for (var item in data) {
            var name = item['name'];
            var index = getIndexFromName(name);
            if (index != -1) {
              _controllers[index].text = item['price'].toString();
            }
          }
        } else {
          _showSnackBar(
              'Failed to fetch prices: Unexpected response format', Colors.red);
        }
      } else {
        _showSnackBar('Failed to fetch prices', Colors.red);
      }
    } catch (e) {
      _showSnackBar('Failed to fetch prices', Colors.red);
    }
  }

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _finishingCostOptions.length +
          _grammagesOfPaper.length +
          _grammagesOfCover.length +
          _printingColor.length +
          _printingColorOfCover.length,
      (_) => TextEditingController(),
    );
    populateFormFields(context);
  }

  void _showSnackBar(String message, Color backgroundColor) {
    if (_scaffoldMessengerState != null) {
      _scaffoldMessengerState!.showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
        ),
      );
    }
  }

  int getIndexFromName(String name) {
    int index = _finishingCostOptions.indexOf(name);
    if (index != -1) return index;

    index = _grammagesOfPaper.indexOf(int.tryParse(name) ?? -1);
    if (index != -1) return index + _finishingCostOptions.length;

    index = _grammagesOfCover.indexOf(int.tryParse(name) ?? -1);
    if (index != -1)
      return index + _finishingCostOptions.length + _grammagesOfPaper.length;

    index = _printingColor.indexWhere((color) => color['name'] == name);
    if (index != -1) {
      return index +
          _finishingCostOptions.length +
          _grammagesOfPaper.length +
          _grammagesOfCover.length;
    }

    index = _printingColorOfCover.indexWhere((color) => color['name'] == name);
    if (index != -1) {
      return index +
          _finishingCostOptions.length +
          _grammagesOfPaper.length +
          _grammagesOfCover.length +
          _printingColor.length;
    }

    return -1;
  }

  void _submitForm() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final token = userProvider.token;

        List<Map<String, dynamic>> prices = [];
        for (int i = 0; i < _controllers.length; i++) {
          String name = '';
          String label = '';

          if (i < _finishingCostOptions.length) {
            label = 'Finishing Cost';
            name = _finishingCostOptions[i];
          } else if (i <
              _finishingCostOptions.length + _grammagesOfPaper.length) {
            label = 'Grammages of Paper (gsm)';
            name =
                _grammagesOfPaper[i - _finishingCostOptions.length].toString();
          } else if (i <
              _finishingCostOptions.length +
                  _grammagesOfPaper.length +
                  _grammagesOfCover.length) {
            label = 'Grammages of Cover (gsm)';
            name = _grammagesOfCover[
                    i - _finishingCostOptions.length - _grammagesOfPaper.length]
                .toString();
          } else if (i <
              _finishingCostOptions.length +
                  _grammagesOfPaper.length +
                  _grammagesOfCover.length +
                  _printingColor.length) {
            label = 'Color(s) of Text';
            name = _printingColor[i -
                    _finishingCostOptions.length -
                    _grammagesOfPaper.length -
                    _grammagesOfCover.length]['name']
                .toString();
          } else if (i <
              _finishingCostOptions.length +
                  _grammagesOfPaper.length +
                  _grammagesOfCover.length +
                  _printingColor.length +
                  _printingColorOfCover.length) {
            label = 'Color(s) of Cover';
            name = _printingColorOfCover[i -
                    _finishingCostOptions.length -
                    _grammagesOfPaper.length -
                    _grammagesOfCover.length -
                    _printingColor.length]['name']
                .toString();
          }

          double price = double.parse(_controllers[i].text);

          prices.add({
            'name': name,
            'label': label,
            'price': price,
          });
        }

        Map<String, dynamic> formData = {
          'prices': prices,
        };

        var url = Uri.parse(getBaseUrl('prices'));
        var response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(formData),
        );

        if (response.statusCode == 201) {
          _formKey.currentState!.reset();
          _scaffoldMessengerState?.showSnackBar(
            SnackBar(
              content: Text('Prices saved successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Future.delayed(Duration(seconds: 5), () {
            Navigator.pushReplacementNamed(context, '/home');
          });
        } else {
          _scaffoldMessengerState?.showSnackBar(
            SnackBar(
              content: Text('Failed to save prices. Error: ${response.body}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        _scaffoldMessengerState?.showSnackBar(
          SnackBar(
              content:
                  Text('Failed to save prices; all fields must be filled!')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _scaffoldMessengerState = ScaffoldMessenger.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Price Settings'),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildCategory(
                    'Finishing Cost',
                    _finishingCostOptions,
                    0,
                    _controllers,
                  ),
                  _buildCategory(
                    'Grammages of Paper (gsm)',
                    _grammagesOfPaper,
                    _finishingCostOptions.length,
                    _controllers,
                  ),
                  _buildCategory(
                    'Grammages of Cover (gsm)',
                    _grammagesOfCover,
                    _finishingCostOptions.length + _grammagesOfPaper.length,
                    _controllers,
                  ),
                  _buildCategory(
                    'Color(s) of Text',
                    _printingColor.map((color) => color['name']).toList(),
                    _finishingCostOptions.length +
                        _grammagesOfPaper.length +
                        _grammagesOfCover.length,
                    _controllers,
                  ),
                  _buildCategory(
                    'Color(s) of Cover',
                    _printingColorOfCover
                        .map((color) => color['name'])
                        .toList(),
                    _finishingCostOptions.length +
                        _grammagesOfPaper.length +
                        _grammagesOfCover.length +
                        _printingColor.length,
                    _controllers,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 17, 142, 245),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Save Price',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ]));
  }

  Widget _buildCategory(
    String categoryName,
    List<dynamic> items,
    int startIndex,
    List<TextEditingController>
        _controllers, // Add this line to include controllers list
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                categoryName.toUpperCase(), // Convert categoryName to uppercase
                style: const TextStyle(
                  fontSize: 18, // Increase the font size here
                  fontWeight: FontWeight.bold, // Make the text bold (optional)
                ),
              ),
            ),
            Divider(),
            for (int i = 0; i < items.length; i++)
              buildPriceField(
                'Price for ${items[i]} ($categoryName)'
                    .toUpperCase(), // Convert label to uppercase
                _controllers[startIndex + i],
              ),
          ],
        ),
      ),
    );
  }

  Widget buildPriceField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixText: '₦ ', // Add the naira symbol as a prefix
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter a price';
          }
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PriceSettings(),
    ),
  );
}
