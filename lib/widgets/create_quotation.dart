import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotation_app/base_url.dart';
import 'package:quotation_app/dummy_data.dart';
import './user_profile.dart';
import './custom_textform_field.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

class QuotationForm extends StatefulWidget {
  const QuotationForm({Key? key}) : super(key: key);

  @override
  State<QuotationForm> createState() => _QuotationFormState();
}

class _QuotationFormState extends State<QuotationForm> {
  final _formKey = GlobalKey<FormState>();

  String _selectedProductName =
      DUMMY_PRODUCT.isNotEmpty ? DUMMY_PRODUCT[0].title : '';
  String _selectedSizeOfPaper = '9 x 6';
  String _selectedPaperColor = 'white';
  String _selectedCardSize = '24.5cm by 36cm';

  final TextEditingController _numberOfCopiesController =
      TextEditingController();
  final TextEditingController _numberOfCoverController =
      TextEditingController();

  final TextEditingController _designCostController = TextEditingController();
  final TextEditingController _plateMakingController = TextEditingController();
  final TextEditingController _runningCostController = TextEditingController();
  final TextEditingController _catTitleController = TextEditingController();

  final TextEditingController _noOfColorTextController =
      TextEditingController();

  final TextEditingController _noOfPageController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final TextEditingController _editingCostController = TextEditingController();
  final TextEditingController _impressionCostController =
      TextEditingController();

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

  late int _selectedGrammageOfPaper;
  late int _selectedGrammageOfCover;

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
  String? _selectedColorText;
  String? _selectedColorCover;

  @override
  void initState() {
    super.initState();
    _selectedGrammageOfPaper = _grammagesOfPaper.first;
    _selectedGrammageOfCover = _grammagesOfCover.first;
  }

  bool _isLoading = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String? token = Provider.of<UserProvider>(context, listen: false).token;

      Map<String, dynamic> formData = {
        'productName': _selectedProductName,
        'productTitle': _catTitleController.text,
        'sizeOfPaper': _selectedSizeOfPaper,
        'paperColor': _selectedPaperColor,
        'grammageForPaper': _selectedGrammageOfPaper,
        'numberOfCopies': int.tryParse(_numberOfCopiesController.text),
        'numberOfCover': _numberOfCoverController.text, // Storing full string
        'grammageOfCard': _selectedGrammageOfCover,
        'sizeOfCard': _selectedCardSize,
        'designCost': int.tryParse(_designCostController.text),
        'plateMakingCost': int.tryParse(_plateMakingController.text),
        'runningCost': int.tryParse(_runningCostController.text),
        'editingCost': int.tryParse(_editingCostController.text),
        'impressionCost': int.tryParse(_impressionCostController.text),
        'noOfColorsText': _noOfColorTextController.text, // Storing full string
        'numberOfPages': int.tryParse(_noOfPageController.text),
        'finishingCosts': _selectedFinishingCosts,
        'address': _addressController.text,
        'date': _dateController.text,
      };

      var url = Uri.parse(getBaseUrl('create_quotation'));

      try {
        var response = await http.post(
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
              content: Text('Quotation created successfully'),
              backgroundColor: Colors.green,
            ),
          );
          _formKey.currentState!.reset();
          setState(() {
            _selectedProductName =
                DUMMY_PRODUCT.isNotEmpty ? DUMMY_PRODUCT[0].title : '';
            _selectedSizeOfPaper = '9 x 6';
            _selectedPaperColor = 'white';
            _selectedFinishingCosts = [];
          });
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacementNamed(context, '/quotations');
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Failed to submit quotation. Error: ${response.body}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $error'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _resetForm() {
    setState(() {
      _selectedProductName =
          DUMMY_PRODUCT.isNotEmpty ? DUMMY_PRODUCT[0].title : '';
      _selectedSizeOfPaper = '9 x 6';
      _selectedPaperColor = 'white';
      _selectedFinishingCosts = [];
      _formKey.currentState!.reset();
    });
  }

  @override
  void dispose() {
    _numberOfCopiesController.dispose();
    _numberOfCoverController.dispose();
    _designCostController.dispose();
    _plateMakingController.dispose();
    _runningCostController.dispose();
    _catTitleController.dispose();
    _noOfColorTextController.dispose();
    _noOfPageController.dispose();
    _addressController.dispose();
    _dateController.dispose();
    _editingCostController.dispose();
    _impressionCostController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Quotation Form',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12.0),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
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
                CustomTextFormField(
                  controller: _catTitleController,
                  labelText: 'Product Title',
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 12.0),
                CustomTextFormField(
                  controller: _addressController,
                  labelText: 'To Address',
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    hintText: 'Select Date',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _dateController.text =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.all(12.0),
                    margin: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Column(
                      children: [
                        const Text(
                          'Paper',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12.0),
                        // TextFormField(
                        //   controller: _noOfColorTextController,
                        //   decoration: InputDecoration(
                        //     labelText: 'Colour(s) of text',
                        //     border: OutlineInputBorder(),
                        //   ),
                        //   keyboardType: TextInputType.number,
                        //   inputFormatters: [
                        //     FilteringTextInputFormatter.digitsOnly,
                        //   ],
                        //   onChanged: (value) {
                        //     if (value.isNotEmpty) {
                        //       final int number = int.tryParse(value) ?? 0;
                        //       if (number > 5) {
                        //         showDialog(
                        //           context: context,
                        //           builder: (context) {
                        //             return AlertDialog(
                        //               title: Text('Error'),
                        //               content: Text(
                        //                   'Please enter a number between 1 and 5.'),
                        //               actions: <Widget>[
                        //                 TextButton(
                        //                   onPressed: () {
                        //                     _noOfColorTextController.clear();
                        //                     Navigator.of(context).pop();
                        //                   },
                        //                   child: Text('OK'),
                        //                 ),
                        //               ],
                        //             );
                        //           },
                        //         );
                        //       }
                        //     }
                        //   },
                        // ),
                        DropdownButtonFormField<String>(
                          value: _selectedColorText,
                          decoration: InputDecoration(
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
                        CustomTextFormField(
                          controller: _noOfPageController,
                          labelText: 'Number of Pages',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 12.0),
                        DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Grammage for Paper',
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
                                    child: Text('$grammage gsm'),
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
                              .map((item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
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
                        const SizedBox(height: 12.0),
                      ],
                    )),
                const SizedBox(height: 12.0),
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.all(12.0),
                    margin: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Column(
                      children: [
                        const Text(
                          'Cover',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12.0),
                        // TextFormField(
                        //   controller: _numberOfCoverController,
                        //   decoration: InputDecoration(
                        //     labelText: 'Colour(s) of cover',
                        //     border: OutlineInputBorder(),
                        //   ),
                        //   keyboardType: TextInputType.number,
                        //   inputFormatters: [
                        //     FilteringTextInputFormatter.digitsOnly,
                        //   ],
                        //   onChanged: (value) {
                        //     if (value.isNotEmpty) {
                        //       final int number = int.tryParse(value) ?? 0;
                        //       if (number > 5) {
                        //         showDialog(
                        //           context: context,
                        //           builder: (context) {
                        //             return AlertDialog(
                        //               title: Text('Error'),
                        //               content: Text(
                        //                   'Please enter a number between 1 and 5.'),
                        //               actions: <Widget>[
                        //                 TextButton(
                        //                   onPressed: () {
                        //                     _numberOfCoverController.clear();
                        //                     Navigator.of(context).pop();
                        //                   },
                        //                   child: Text('OK'),
                        //                 ),
                        //               ],
                        //             );
                        //           },
                        //         );
                        //       }
                        //     }
                        //   },
                        // ),
                        DropdownButtonFormField<String>(
                          value: _selectedColorCover,
                          decoration: InputDecoration(
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
                            labelText: 'Grammage for Cover',
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
                                    child: Text('$grammage gsm'),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 12.0),
                      ],
                    )),
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
                      .map((item) => DropdownMenuItem<String>(
                            value: item['value'] as String,
                            child: Text(item['name'] as String),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 12.0),
                CustomTextFormField(
                  controller: _numberOfCopiesController,
                  labelText: 'Number of Copies',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12.0),
                CustomTextFormField(
                  controller: _designCostController,
                  labelText: 'Graphics Design Cost',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Graphics Designer Cost (₦) ',
                    border: OutlineInputBorder(),
                    prefixText: '₦',
                  ),
                ),
                const SizedBox(height: 12.0),
                CustomTextFormField(
                  controller: _plateMakingController,
                  labelText: 'Plate Making Cost',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Plate Making Cost (₦) ',
                    border: OutlineInputBorder(),
                    prefixText: '₦',
                  ),
                ),
                const SizedBox(height: 12.0),
                CustomTextFormField(
                  controller: _runningCostController,
                  labelText: 'Running Cost (Offset)',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Running Cost (Offset) (₦) ',
                    border: OutlineInputBorder(),
                    prefixText: '₦',
                  ),
                ),
                const SizedBox(height: 15.0),
                CustomTextFormField(
                  controller: _editingCostController,
                  labelText: 'Editing Cost',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Editing Cost (₦) ',
                    border: OutlineInputBorder(),
                    prefixText: '₦',
                  ),
                ),
                const SizedBox(height: 15.0),
                CustomTextFormField(
                  controller: _impressionCostController,
                  labelText: 'Impression Cost',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Impression Cost (₦) ',
                    border: OutlineInputBorder(),
                    prefixText: '₦',
                  ),
                ),
                const SizedBox(height: 15.0),
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
                    children: _finishingCostOptions.map((cost) {
                      return CheckboxListTile(
                        title: Text(cost),
                        value: _selectedFinishingCosts.contains(cost),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value != null) {
                              if (value) {
                                _selectedFinishingCosts.add(cost);
                              } else {
                                _selectedFinishingCosts.remove(cost);
                              }
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12.0),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : (_formKey.currentState != null &&
                              _formKey.currentState!.validate())
                          ? _submitForm
                          : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      (_formKey.currentState != null &&
                              _formKey.currentState!.validate())
                          ? Colors.blue
                          : Colors.grey,
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
                      (_formKey.currentState != null &&
                              _formKey.currentState!.validate())
                          ? Colors.white
                          : Colors.black,
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
                      : const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    ]));
  }
}
