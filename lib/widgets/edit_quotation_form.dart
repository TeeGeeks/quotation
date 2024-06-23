import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../base_url.dart';
import '../dummy_data.dart';
import '../quotations.dart';
import 'package:http/http.dart' as http;
import './main_drawer.dart';
import 'dart:convert';

import 'package:quotation_app/widgets/user_profile.dart';

class EditQuotationForm extends StatefulWidget {
  final Quotation quotation;

  const EditQuotationForm({super.key, required this.quotation});

  @override
  _EditQuotationFormState createState() => _EditQuotationFormState();
}

class _EditQuotationFormState extends State<EditQuotationForm> {
  final _formKey = GlobalKey<FormState>();

  late String _selectedProductName;
  late String _selectedSizeOfPaper;
  late String _selectedPaperColor;
  late String _selectedCardSize;

  final TextEditingController _numberOfCopiesController =
      TextEditingController();
  final TextEditingController _categoryTitleController =
      TextEditingController();
  final TextEditingController _numberOfCoverController =
      TextEditingController();
  final TextEditingController _designCostController = TextEditingController();
  final TextEditingController _plateMakingController = TextEditingController();
  final TextEditingController _runningCostController = TextEditingController();
  final TextEditingController _noOfColorTextController =
      TextEditingController();
  final TextEditingController _noOfPageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _editingCostController = TextEditingController();
  final TextEditingController _impressionCostController =
      TextEditingController();

  late int _selectedGrammageOfPaper;
  late int _selectedGrammageOfCover;

  final List<String> _sizesOfPaper = [
    '9 x 6',
    '8.5 x 11',
    '4 x 6',
    '8.27 x 10.5',
    '5.83 x 8.27',
    '4.13 x 5.83',
    '2.91 x 4.13',
    '2.05 x 2.91'
  ];

  final List<Map<String, dynamic>> _cardSize = [
    {'name': '24.5cm by 36cm', 'value': '24.5cm by 36cm'},
    {'name': '20cm by 30cm', 'value': '20cm by 30cm'},
  ];

  final List<int> _grammagesOfPaper = [50, 55, 60, 70, 75, 80, 90, 110];

  final List<int> _grammagesOfCover = [180, 210, 250, 300, 400];
  List<String> _selectedFinishingCosts = [];

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
  bool _isLoading = false;
  bool _finishingCostsSelected = false;
  String? _selectedColorText;
  String? _selectedColorCover;

  @override
  void initState() {
    super.initState();
    _selectedProductName = widget.quotation.productName;
    _categoryTitleController.text = widget.quotation.productTitle;
    _selectedSizeOfPaper = widget.quotation.sizeOfPaper;
    _selectedPaperColor = widget.quotation.paperColor;
    _selectedCardSize = widget.quotation.sizeOfCard;
    _selectedGrammageOfPaper = widget.quotation.grammageForPaper;
    _selectedGrammageOfCover = widget.quotation.grammageOfCard;
    _selectedFinishingCosts = widget.quotation.finishingCosts;
    _numberOfCopiesController.text = widget.quotation.numberOfCopies.toString();
    _designCostController.text = widget.quotation.designCost.toString();
    _plateMakingController.text = widget.quotation.plateMakingCost.toString();
    _runningCostController.text = widget.quotation.runningCost.toString();
    _noOfPageController.text = widget.quotation.numberOfPages.toString();
    _addressController.text = widget.quotation.address;
    _dateController.text =
        DateFormat('yyyy-MM-dd').format(widget.quotation.date);
    _editingCostController.text = widget.quotation.editingCost.toString();
    _impressionCostController.text = widget.quotation.impressionCost.toString();
    _selectedColorText = widget.quotation.noOfColorsText;
    _selectedColorCover = widget.quotation.numberOfCover;
  }

  void _updateQuotation() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      // Get token from provider
      String? token = Provider.of<UserProvider>(context, listen: false).token;

      // Create a map with updated quotation data
      Map<String, dynamic> formData = {
        'productName': _selectedProductName,
        'productTitle': _categoryTitleController.text,
        'sizeOfPaper': _selectedSizeOfPaper,
        'paperColor': _selectedPaperColor,
        'sizeOfCard': _selectedCardSize,
        'numberOfCopies': int.tryParse(_numberOfCopiesController.text),
        'numberOfCover': _selectedColorCover,
        'designCost': int.tryParse(_designCostController.text),
        'plateMakingCost': int.tryParse(_plateMakingController.text),
        'runningCost': int.tryParse(_runningCostController.text),
        'noOfColorsText': _selectedColorText, // Updated field
        'numberOfPages': int.tryParse(_noOfPageController.text),
        'address': _addressController.text,
        'date': _dateController.text,
        'grammageForPaper': _selectedGrammageOfPaper,
        'grammageOfCard': _selectedGrammageOfCover,
        'finishingCosts': _selectedFinishingCosts,
        'editingCost': int.tryParse(_editingCostController.text),
        'impressionCost': int.tryParse(_impressionCostController.text),
        'colorOfCover': _selectedColorCover, // Updated field
      };

      // Send update request to server
      var url = Uri.parse(getBaseUrl('quotations/${widget.quotation.id}'));
      try {
        var response = await http.put(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(formData),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Quotation updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacementNamed(context, '/quotations');
          }); // Close the edit form
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Failed to update quotation. Error: ${response.body}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update quotation. Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Quotation'),
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
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Edit Quotation',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12.0),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedProductName,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedProductName = value!;
                      });
                    },
                    items: DUMMY_PRODUCT
                        .map((product) => DropdownMenuItem<String>(
                              value: product.title,
                              child: Text(product.title),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Product Title',
                      border: OutlineInputBorder(),
                    ),
                    controller: _categoryTitleController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the product title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                    controller: _addressController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(),
                      hintText: 'Select Date',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: _dateController,
                    onTap: () async {
                      // Show Date Picker
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );

                      // Update the text field if a date is selected
                      if (pickedDate != null) {
                        setState(() {
                          _dateController.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        });
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the date';
                      }
                      return null;
                    },
                  ),
                  Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      margin: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(children: [
                        const Text(
                          'Paper',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12.0),
                        DropdownButtonFormField<String>(
                          value: _selectedColorText,
                          decoration: const InputDecoration(
                            labelText: 'Colour(s) of text',
                            border: OutlineInputBorder(),
                          ),
                          items: List.generate(
                                  5, (index) => '${index + 1} color of text')
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedColorText = newValue;
                              _noOfColorTextController.text =
                                  newValue ?? ''; // Update the controller
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a color option.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12.0),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Number of Pages',
                            border: OutlineInputBorder(),
                          ),
                          controller: _noOfPageController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the number of pages';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12.0),
                        DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Grammage of Paper',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedGrammageOfPaper,
                          onChanged: (int? value) {
                            setState(() {
                              _selectedGrammageOfPaper = value!;
                            });
                          },
                          items: _grammagesOfPaper
                              .map((grammage) => DropdownMenuItem<int>(
                                    value: grammage,
                                    child: Text(grammage.toString()),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 12.0),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Size of Paper',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedSizeOfPaper,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedSizeOfPaper = value!;
                            });
                          },
                          items: _sizesOfPaper
                              .map((size) => DropdownMenuItem<String>(
                                    value: size,
                                    child: Text(size),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 12.0),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Paper Color',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedPaperColor,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedPaperColor = value!;
                            });
                          },
                          items: ['white', 'brown']
                              .map((color) => DropdownMenuItem<String>(
                                    value: color,
                                    child: Text(color),
                                  ))
                              .toList(),
                        ),
                      ])),
                  const SizedBox(height: 12.0),
                  Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      margin: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(children: [
                        const Text(
                          'Cover',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12.0),
                        DropdownButtonFormField<String>(
                          value: _selectedColorCover,
                          decoration: const InputDecoration(
                            labelText: 'Colour(s) of cover',
                            border: OutlineInputBorder(),
                          ),
                          items: List.generate(
                                  5, (index) => '${index + 1} color of cover')
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedColorCover = newValue;
                              _numberOfCoverController.text =
                                  newValue ?? ''; // Update the controller
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a color option.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12.0),
                        DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Grammage of Cover',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedGrammageOfCover,
                          onChanged: (int? value) {
                            setState(() {
                              _selectedGrammageOfCover = value!;
                            });
                          },
                          items: _grammagesOfCover
                              .map((grammage) => DropdownMenuItem<int>(
                                    value: grammage,
                                    child: Text(grammage.toString()),
                                  ))
                              .toList(),
                        ),
                      ])),
                  const SizedBox(height: 12.0),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Size of Card',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedCardSize,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedCardSize = value!;
                      });
                    },
                    items: _cardSize
                        .map((card) => DropdownMenuItem<String>(
                              value: card['value'],
                              child: Text(card['name']),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Number of Copies',
                      border: OutlineInputBorder(),
                    ),
                    controller: _numberOfCopiesController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the number of copies';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Graphics Design Cost',
                      border: OutlineInputBorder(),
                    ),
                    controller: _designCostController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the design cost';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Plate Making Cost',
                      border: OutlineInputBorder(),
                    ),
                    controller: _plateMakingController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the plate making cost';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Running Cost',
                      border: OutlineInputBorder(),
                    ),
                    controller: _runningCostController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Editing Cost',
                      border: OutlineInputBorder(),
                    ),
                    controller: _editingCostController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Impression Cost',
                      border: OutlineInputBorder(),
                    ),
                    controller: _impressionCostController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the impression cost';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  const Text(
                    'Finishing Cost',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.all(12.0),
                    margin: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Finishing Cost',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        ..._finishingCostOptions
                            .map((option) => CheckboxListTile(
                                  title: Text(option),
                                  value:
                                      _selectedFinishingCosts.contains(option),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value!) {
                                        _selectedFinishingCosts.add(option);
                                      } else {
                                        _selectedFinishingCosts.remove(option);
                                      }
                                      _finishingCostsSelected =
                                          _selectedFinishingCosts.isNotEmpty;
                                    });
                                  },
                                )),
                        if (_finishingCostsSelected == false)
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Please select at least one finishing cost',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _updateQuotation,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        _isLoading ? Colors.grey : Colors.blue,
                      ),
                      foregroundColor: WidgetStateProperty.all<Color>(
                        _isLoading ? Colors.black : Colors.white,
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
                        : const Text('Edit'),
                  )
                ],
              ),
            ),
          ),
        ]));
  }
}
