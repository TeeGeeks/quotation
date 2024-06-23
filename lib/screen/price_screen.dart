import 'package:flutter/material.dart';

class FieldPricing {
  final String fieldName;
  final int price;

  FieldPricing(this.fieldName, this.price);
}

class QuotationForm extends StatefulWidget {
<<<<<<< HEAD
  const QuotationForm({super.key});

=======
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
  @override
  _QuotationFormState createState() => _QuotationFormState();
}

class _QuotationFormState extends State<QuotationForm> {
<<<<<<< HEAD
  final List<FieldPricing> _fieldPricingList = [];
=======
  List<FieldPricing> _fieldPricingList = [];
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e

  void _addFieldPrice(String fieldName, int price) {
    setState(() {
      _fieldPricingList.add(FieldPricing(fieldName, price));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
<<<<<<< HEAD
          title: const Text('Quotation Form'),
=======
          title: Text('Quotation Form'),
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
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
<<<<<<< HEAD
                    child: const Text('Add Field Pricing'),
                  ),
                  const SizedBox(height: 20.0),
                  const Text('Field Pricing List'),
=======
                    child: Text('Add Field Pricing'),
                  ),
                  SizedBox(height: 20.0),
                  Text('Field Pricing List'),
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
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
<<<<<<< HEAD
          title: const Text('Add Field Pricing'),
=======
          title: Text('Add Field Pricing'),
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  fieldName = value;
                },
<<<<<<< HEAD
                decoration: const InputDecoration(labelText: 'Field Name'),
=======
                decoration: InputDecoration(labelText: 'Field Name'),
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
              ),
              TextField(
                onChanged: (value) {
                  price = int.tryParse(value) ?? 0;
                },
<<<<<<< HEAD
                decoration: const InputDecoration(labelText: 'Price'),
=======
                decoration: InputDecoration(labelText: 'Price'),
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
<<<<<<< HEAD
              child: const Text('Cancel'),
=======
              child: Text('Cancel'),
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
            ),
            TextButton(
              onPressed: () {
                _addFieldPrice(fieldName, price);
                Navigator.of(context).pop();
              },
<<<<<<< HEAD
              child: const Text('Add'),
=======
              child: Text('Add'),
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
            ),
          ],
        );
      },
    );
  }
}

void main() {
<<<<<<< HEAD
  runApp(const MaterialApp(
=======
  runApp(MaterialApp(
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
    home: QuotationForm(),
  ));
}
