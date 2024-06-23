import 'package:flutter/material.dart';

class FieldPricing {
  final String fieldName;
  final int price;

  FieldPricing(this.fieldName, this.price);
}

class QuotationForm extends StatefulWidget {
  const QuotationForm({super.key});

  @override
  _QuotationFormState createState() => _QuotationFormState();
}

class _QuotationFormState extends State<QuotationForm> {
  final List<FieldPricing> _fieldPricingList = [];

  void _addFieldPrice(String fieldName, int price) {
    setState(() {
      _fieldPricingList.add(FieldPricing(fieldName, price));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Quotation Form'),
        ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showFieldPriceDialog(context);
                    },
                    child: const Text('Add Field Pricing'),
                  ),
                  const SizedBox(height: 20.0),
                  const Text('Field Pricing List'),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _fieldPricingList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_fieldPricingList[index].fieldName),
                        subtitle: Text(
                            '₦${_fieldPricingList[index].price.toString()}'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ]));
  }

  void _showFieldPriceDialog(BuildContext context) {
    String fieldName = '';
    int price = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Field Pricing'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  fieldName = value;
                },
                decoration: const InputDecoration(labelText: 'Field Name'),
              ),
              TextField(
                onChanged: (value) {
                  price = int.tryParse(value) ?? 0;
                },
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addFieldPrice(fieldName, price);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: QuotationForm(),
  ));
}
