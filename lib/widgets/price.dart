import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quotation_app/dummy_data.dart';
import './custom_textform_field.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class QuotationForm extends StatefulWidget {
  const QuotationForm({Key? key}) : super(key: key);

  @override
  State<QuotationForm> createState() => _QuotationFormState();
}

class _QuotationFormState extends State<QuotationForm> {
  final _formKey = GlobalKey<FormState>();

  String _selectedProductName =
      DUMMY_PRODUCT.isNotEmpty ? DUMMY_PRODUCT[0].title : '';
  String _selectedSizeOfPaper = 'A4';
  String _selectedPaperColor = 'white';
  String _selectedCardSize = '24.5cm by 36cm'; // Using unique identifier
  String _selectedFinishingCost = 'Binding';
  String _selectedCoverColor = 'one_color';
  String _selectedPrintingColor = 'one_color'; // Default to 'One Color'

  final TextEditingController _quantityController = TextEditingController();
  // final TextEditingController _sizeOfCardController = TextEditingController();
  final TextEditingController _pagesNumbersController = TextEditingController();

  final TextEditingController _designCostController = TextEditingController();
  final TextEditingController _plateMakingController = TextEditingController();
  final TextEditingController _runningCostController = TextEditingController();

  final List<String> _sizesOfPaper = [
    'A0',
    'A1',
    'A2',
    'A3',
    'A4',
    'A5',
    'Tabloid',
    'Letter',
    'Legal'
  ];
  final List<Map<String, dynamic>> _paperColors = [
    {'name': 'White', 'value': 'white'},
    {'name': 'Brown', 'value': 'brown'},
  ];

  final List<Map<String, dynamic>> _cardSize = [
    {'name': '24.5cm by 36cm', 'value': '24.5cm by 36cm'},
    {'name': '20cm by 30cm', 'value': '20cm by 30cm'},
  ];

  final List<Map<String, dynamic>> _printingColors = [
    {'name': 'One Color', 'value': 'one_color'},
    {'name': 'Two Color', 'value': 'two_color'},
    {'name': 'Full Color', 'value': 'full_color'}
  ];

  final List<String> _finishingCosts = [
    'Binding',
    'Stitching',
    'Lamination',
    'Folding'
  ];

  late int _selectedGrammageOfPaper;
  late int _selectedGrammageOfCard;

  final List<int> _grammagesOfPaper = [50, 55, 60, 70, 75, 80, 90, 110];

  final List<int> _grammagesOfCard = [180, 210, 250, 300, 400];

  final List<Map<String, dynamic>> _coverColors = [
    {'name': 'One Color', 'value': 'one_color'},
    {'name': 'Two Color', 'value': 'two_color'},
    {'name': 'Full Color', 'value': 'full_color'}
  ];

  @override
  void initState() {
    super.initState();
    _selectedGrammageOfPaper = _grammagesOfPaper.first;
    _selectedGrammageOfCard = _grammagesOfCard.first;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> formData = {
        'productName': _selectedProductName,
        'sizeOfPaper': _selectedSizeOfPaper,
        'paperColor': _selectedPaperColor,
        'pagesNumber': int.tryParse(_pagesNumbersController.text),
        'grammageForPaper': _selectedGrammageOfPaper,
        'coverColor': _selectedCoverColor,
        'printingColor': _selectedPrintingColor,
        'quantity': int.tryParse(_quantityController.text),
        'grammageOfCard': _selectedGrammageOfCard,
        'sizeOfCard': _selectedCardSize,
        'designCost': int.tryParse(_designCostController.text),
        'plateMakingCost': int.tryParse(_plateMakingController.text),
        'runningCost': int.tryParse(_runningCostController.text),
        'finishing': _selectedFinishingCost,
      };

      var url = Uri.parse('http://192.168.137.210:3000/create_quotation');

      try {
        var response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(formData),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Form submitted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          _formKey.currentState!.reset();
          setState(() {
            _selectedProductName =
                DUMMY_PRODUCT.isNotEmpty ? DUMMY_PRODUCT[0].title : '';
            _selectedSizeOfPaper = 'A4';
            _selectedPaperColor = 'white'; // Using unique identifier
            _selectedFinishingCost = 'Binding';
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to submit form. Error: ${response.body}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit form. Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                          items: _paperColors
                              .map((item) => DropdownMenuItem<String>(
                                    value: item['value'] as String,
                                    child: Text(item['name'] as String),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 12.0),
                        CustomTextFormField(
                          controller: _pagesNumbersController,
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
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: ' Cover Color',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedCoverColor,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedCoverColor = value!;
                            });
                          },
                          items: _coverColors
                              .map((item) => DropdownMenuItem<String>(
                                    value: item['value'] as String,
                                    child: Text(item['name'] as String),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 12.0),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: ' Printing Color',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedCoverColor,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedPrintingColor = value!;
                            });
                          },
                          items: _printingColors
                              .map((item) => DropdownMenuItem<String>(
                                    value: item['value'] as String,
                                    child: Text(item['name'] as String),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 12.0),
                        CustomTextFormField(
                          controller: _quantityController,
                          labelText: 'Number of Copies',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 12.0),
                      ],
                    )),
                const SizedBox(height: 12.0),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Grammage of Card',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedGrammageOfCard,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedGrammageOfCard = value!;
                    });
                  },
                  items: _grammagesOfCard
                      .map((grammage) => DropdownMenuItem<int>(
                            value: grammage,
                            child: Text('$grammage gsm'),
                          ))
                      .toList(),
                ),
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
                // CustomTextFormField(
                //   controller: _sizeOfCardController,
                //   labelText: 'Size of Card',
                //   keyboardType: TextInputType.number,
                // ),
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
                const SizedBox(height: 12.0),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Finishing',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedFinishingCost,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedFinishingCost = value!;
                    });
                  },
                  items: _finishingCosts
                      .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 12.0),
                ElevatedButton(
                  onPressed: _formKey.currentState?.validate() ?? false
                      ? _submitForm
                      : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      _formKey.currentState?.validate() ?? false
                          ? Colors.blue
                          : Colors.grey,
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
                      _formKey.currentState?.validate() ?? false
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
