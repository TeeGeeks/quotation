import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quotation_app/get_price.dart';
import 'package:quotation_app/get_user.dart';
import 'package:quotation_app/screen/pdf_screen.dart';
import 'package:quotation_app/screen/quotation%20calculator.dart';
import 'package:quotation_app/widgets/main_drawer.dart';

class QuotationDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> quotationData;
  final List<Price> prices;
  final User? user; // Add the user parameter
  final String? userLogo; // Add the userLogo parameter

  QuotationDetailsScreen({
    required this.quotationData,
    required this.prices,
    this.user, // Initialize the user parameter
    this.userLogo, // Initialize the userLogo parameter
  });

  var formatter = NumberFormat.currency(locale: 'en_US', symbol: '₦');

  @override
  Widget build(BuildContext context) {
    if (prices.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quotation Details'),
        ),
        drawer: MainDrawer(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info_outline, size: 72.0, color: Colors.grey),
                const SizedBox(height: 24.0),
                const Text(
                  'Prices for this quotation have not been entered yet. Please add prices.',
                  style: TextStyle(fontSize: 18.0, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/price_settings');
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 17, 142, 245),
                    ),
                  ),
                  child: const Text(
                    'Go to Price Settings Page',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Map<String, dynamic> calculatedValues =
        QuotationCalculator.calculateQuotationDetails(quotationData, prices);
    String formattedGrandPrice = calculatedValues['formattedGrandPrice'];

    return Scaffold(
        body: PdfScreen(
      title: 'Quotation Details',
      content: [
        Center(
          child: Text(
            user?.companyName ?? '',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Divider(),
        const SizedBox(height: 10),
        Center(
          child: Text(
            'QUOTATION INVOICE FOR ${quotationData['Number of Copies']} COPIES OF ${quotationData['Product Name']?.toUpperCase()}: (${quotationData['Product Title']?.toUpperCase()})',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              child: SizedBox(
                width: 50,
                height: 40,
                child: userLogo != null
                    ? Image.network(
                        userLogo!,
                        fit: BoxFit.contain,
                      )
                    : Container(
                        child: const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
              ),
            ),
            Spacer(),
            Flexible(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.companyAddress ?? '',
                      style: const TextStyle(
                          fontSize: 13, fontStyle: FontStyle.italic),
                    ),
                    Text(
                      user?.email ?? ' ',
                      style: const TextStyle(
                          fontSize: 13, fontStyle: FontStyle.italic),
                    ),
                    Text(
                      user?.phone ?? ' ',
                      style: const TextStyle(
                          fontSize: 13, fontStyle: FontStyle.italic),
                    ),
                    Text(
                      user?.companyWebsite ?? '',
                      style: const TextStyle(
                          fontSize: 13, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Divider(),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'To: ${quotationData['Address'] ?? ''}',
                softWrap: true, // Allow text to wrap to the next line
              ),
            ),
            Text(
              'Date: ${quotationData['Date'] != null ? DateFormat('MMMM d, yyyy').format(DateTime.parse(quotationData['Date'])) : ''}',
            ),
          ],
        ),
        const Divider(),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Username: ${user?.username ?? 'User'}',
                softWrap: true, // Allow text to wrap to the next line
              ),
            ),
            Text(
              'Payment terms: ${quotationData['paymentTerms'] ?? 'One Payment'}',
            ),
          ],
        ),
        const Divider(),
        const SizedBox(height: 20),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(3),
          },
          border: TableBorder.all(),
          children: [
            TableRow(
              children: [
                TableCell(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    color: Colors.grey[300],
                    child: const Text(
                      'Quotations',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    color: Colors.grey[300],
                    child: const Text(
                      'Value Entered',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ...quotationData.entries.take(17).map(
              (entry) {
                return TableRow(
                  children: [
                    TableCell(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8),
                        child: Text(entry.key),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8),
                        child: Text(entry.value.toString()),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 30.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(
                label: Text(
                  'Quotation Item Per Unit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Price (₦)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
            rows: [
              DataRow(cells: [
                const DataCell(Text('Cost unit of paper grammage')),
                DataCell(Text(
                    '₦ ${calculatedValues['pricePerSheetOfPaperGrammage'].toString()}')),
              ]),
              DataRow(cells: [
                const DataCell(Text('Cost unit of cover grammage')),
                DataCell(Text(
                    '₦ ${calculatedValues['priceOfSheetOfCoverGrammage'].toString()}')),
              ]),
              DataRow(cells: [
                const DataCell(Text('Printing Color (Text)')),
                DataCell(Text(
                    '₦ ${calculatedValues['pricePerSheetOfPrintingColorText'].toString()}')),
              ]),
              DataRow(cells: [
                const DataCell(Text('Printing Color (Cover)')),
                DataCell(Text(
                    '₦ ${calculatedValues['pricePerSheetOfPrintingColorCover'].toString()}')),
              ]),
              DataRow(cells: [
                const DataCell(Text('Finishing Cost')),
                DataCell(Text(
                    '₦ ${calculatedValues['totalFinishingCost'].toString()}')),
              ]),
              DataRow(cells: [
                const DataCell(Text('Plate Making Cost')),
                DataCell(Text(
                    '₦ ${calculatedValues['plateMakingCost'].toString()}')),
              ]),
              DataRow(cells: [
                const DataCell(Text('Running Cost')),
                DataCell(Text(
                    '₦ ${calculatedValues['runningCost'] == null || calculatedValues['runningCost'].toString() == 'null' ? '-' : calculatedValues['runningCost'].toString()}')),
              ]),
              DataRow(cells: [
                const DataCell(Text('Designer Cost')),
                DataCell(
                    Text('₦ ${calculatedValues['designerCost'].toString()}')),
              ]),
              DataRow(cells: [
                const DataCell(Text('Editing Cost')),
                DataCell(
                    Text('₦ ${calculatedValues['editingCost'].toString()}')),
              ]),
              DataRow(cells: [
                const DataCell(Text('Impression Cost')),
                DataCell(
                    Text('₦ ${calculatedValues['impressionCost'].toString()}')),
              ]),
              DataRow(cells: [
                const DataCell(Text(
                  'Cost of Printing Per Unit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                )),
                DataCell(Text(
                  '${calculatedValues['totalPricePerUnit']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                )),
              ]),
              DataRow(cells: [
                const DataCell(Text(
                  'Grand Total',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )),
                DataCell(
                  Text(
                    formattedGrandPrice.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quotation Calculation:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Divider(),
                  SizedBox(height: 8),
                  ListTile(
                    title: Text(
                      'Cost of Printing Per Unit:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text('Cost unit of paper grammage\n'
                        'plus Cost unit of cover grammage\n'
                        'plus Printing color (Text) \n'
                        'plus Printing color (Cover) \n'
                        'plus Finishing cost \n'
                        'plus Plate Making cost\n'
                        'plus Running cost\n'
                        'plus Designer cost\n'
                        'plus Editing cost\n'
                        'plus Impression cost\n'),
                  ),
                  ListTile(
                    title: Text(
                      'Grand Total:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Cost of Printing Per Unit\n'
                      'Multiple by Number of copies',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
