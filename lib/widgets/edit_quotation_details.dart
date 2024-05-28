// import 'package:flutter/material.dart';
// import 'package:quotation_app/quotations.dart';

// class EditQuotationForm extends StatefulWidget {
//   final Quotation quotation;
//   final Function(Quotation) onUpdate;

//   EditQuotationForm({required this.quotation, required this.onUpdate});

//   @override
//   _EditQuotationFormState createState() => _EditQuotationFormState();
// }

// class _EditQuotationFormState extends State<EditQuotationForm> {
//   late Quotation _editedQuotation;
//   late TextEditingController _productNameController;
//   late TextEditingController _numberOfCopiesController;
//   late TextEditingController _numberOfCoverController;
//   late TextEditingController _designCostController;
//   late TextEditingController _plateMakingController;
//   late TextEditingController _runningCostController;
//   late TextEditingController _catTitleController;
//   late TextEditingController _noOfColorTextController;
//   late TextEditingController _noOfPageController;
//   late TextEditingController _addressController;
//   late TextEditingController _dateController;

//   @override
//   void initState() {
//     super.initState();
//     _editedQuotation = widget.quotation;
//     _productNameController =
//         TextEditingController(text: _editedQuotation.productName);
//     _numberOfCopiesController =
//         TextEditingController(text: _editedQuotation.numberOfCopies.toString());
//     _numberOfCoverController =
//         TextEditingController(text: _editedQuotation.numberOfCover.toString());
//     _designCostController =
//         TextEditingController(text: _editedQuotation.designCost.toString());
//     _plateMakingController = TextEditingController(
//         text: _editedQuotation.plateMakingCost.toString());
//     _runningCostController =
//         TextEditingController(text: _editedQuotation.runningCost.toString());
//     _catTitleController =
//         TextEditingController(text: _editedQuotation.productTitle);
//     _noOfColorTextController =
//         TextEditingController(text: _editedQuotation.noOfColorsText.toString());
//     _noOfPageController =
//         TextEditingController(text: _editedQuotation.numberOfPages.toString());
//     _addressController = TextEditingController(text: _editedQuotation.address);
//     _dateController =
//         TextEditingController(text: _editedQuotation.date.toString());
//   }

//   @override
//   void dispose() {
//     _productNameController.dispose();
//     _numberOfCopiesController.dispose();
//     _numberOfCoverController.dispose();
//     _designCostController.dispose();
//     _plateMakingController.dispose();
//     _runningCostController.dispose();
//     _catTitleController.dispose();
//     _noOfColorTextController.dispose();
//     _noOfPageController.dispose();
//     _addressController.dispose();
//     _dateController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Quotation'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save),
//             onPressed: () {
//               widget.onUpdate(_editedQuotation);
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Product Name:'),
//               TextFormField(
//                 controller: _productNameController,
//                 onChanged: (value) {
//                   setState(() {
//                     _editedQuotation.productName = value;
//                   });
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               Text('Number of Copies:'),
//               TextFormField(
//                 controller: _numberOfCopiesController,
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   setState(() {
//                     _editedQuotation.numberOfCopies = int.parse(value);
//                   });
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               Text('Number of Cover:'),
//               TextFormField(
//                 controller: _numberOfCoverController,
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   setState(() {
//                     _editedQuotation.numberOfCover = int.parse(value);
//                   });
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               Text('Design Cost:'),
//               TextFormField(
//                 controller: _designCostController,
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   setState(() {
//                     _editedQuotation.designCost = double.parse(value).toInt();
//                   });
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               Text('Plate Making Cost:'),
//               TextFormField(
//                 controller: _plateMakingController,
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   setState(() {
//                     _editedQuotation.plateMakingCost = int.parse(value);
//                   });
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               Text('Running Cost:'),
//               TextFormField(
//                 controller: _runningCostController,
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   setState(() {
//                     _editedQuotation.runningCost = int.parse(value);
//                   });
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               Text('Category Title:'),
//               TextFormField(
//                 controller: _catTitleController,
//                 onChanged: (value) {
//                   setState(() {
//                     _editedQuotation.productTitle = value;
//                   });
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               Text('Number of Colors (Text):'),
//               TextFormField(
//                 controller: _noOfColorTextController,
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   setState(() {
//                     _editedQuotation.noOfColorsText = int.parse(value);
//                   });
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               Text('Number of Pages:'),
//               TextFormField(
//                 controller: _noOfPageController,
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   setState(() {
//                     _editedQuotation.numberOfPages = int.parse(value);
//                   });
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               Text('Address:'),
//               TextFormField(
//                 controller: _addressController,
//                 onChanged: (value) {
//                   setState(() {
//                     _editedQuotation.address = value;
//                   });
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               Text('Date:'),
//               TextFormField(
//                 controller: _dateController,
//                 onChanged: (value) {
//                   setState(() {
//                     _editedQuotation.date = DateTime.parse(value);
//                   });
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
