// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pdfLib;
// import 'package:quotation_app/widgets/main_drawer.dart';
// import 'package:open_file/open_file.dart';

// class PdfScreen extends StatefulWidget {
//   final String title;
//   final List<Widget> content;

//   const PdfScreen({Key? key, required this.title, required this.content})
//       : super(key: key);

//   @override
//   _PdfScreenState createState() => _PdfScreenState();
// }

// class _PdfScreenState extends State<PdfScreen> {
//   Future<void> _savePdf(BuildContext context) async {
//     try {
//       final pdfLib.Document pdf = pdfLib.Document();

//       pdf.addPage(
//         pdfLib.MultiPage(
//           pageFormat: PdfPageFormat.a4,
//           build: (context) {
//             return widget.content
//                 .map((widget) => _convertWidgetToPdfWidget(widget))
//                 .toList();
//           },
//         ),
//       );

//       final Directory directory = await getApplicationDocumentsDirectory();
//       final String path = '${directory.path}/quotation.pdf';
//       final File file = File(path);
//       await file.writeAsBytes(await pdf.save());

//       OpenFile.open(path);
//       print('File saved to: $path');

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('PDF saved successfully.'),
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     } catch (error) {
//       print('Failed to save PDF: $error');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to save PDF: $error'),
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   pdfLib.Widget _convertWidgetToPdfWidget(Widget widget) {
//     if (widget is Text) {
//       return pdfLib.Text(widget.data ?? '',
//           style: pdfLib.TextStyle(fontSize: widget.style?.fontSize ?? 12));
//     } else if (widget is Padding) {
//       return pdfLib.Padding(
//         padding: pdfLib.EdgeInsets.all(widget.padding.horizontal),
//         child: _convertWidgetToPdfWidget(widget.child!),
//       );
//     } else if (widget is Center) {
//       return pdfLib.Center(
//         child: _convertWidgetToPdfWidget(widget.child!),
//       );
//     } else if (widget is Row) {
//       return pdfLib.Row(
//         children:
//             widget.children.map((e) => _convertWidgetToPdfWidget(e)).toList(),
//       );
//     } else if (widget is Column) {
//       return pdfLib.Column(
//         children:
//             widget.children.map((e) => _convertWidgetToPdfWidget(e)).toList(),
//       );
//     } else if (widget is Container) {
//       return pdfLib.Container(
//         alignment: widget.alignment == Alignment.center
//             ? pdfLib.Alignment.center
//             : pdfLib.Alignment.topLeft,
//         padding: pdfLib.EdgeInsets.all(widget.padding?.horizontal ?? 0),
//         child: _convertWidgetToPdfWidget(widget.child!),
//       );
//     } else if (widget is DataTable) {
//       final List<List<String>> data = widget.rows.map((row) {
//         return row.cells.map((cell) {
//           if (cell.child is Text) {
//             return (cell.child as Text).data ?? '';
//           } else {
//             return '';
//           }
//         }).toList();
//       }).toList();

//       final List<String> headers = widget.columns
//           .map((column) => (column.label as Text).data ?? '')
//           .toList();

//       return pdfLib.Column(
//         children: [
//           pdfLib.Table.fromTextArray(
//             headers: headers,
//             data: data,
//           ),
//           pdfLib.SizedBox(
//               height: 10), // Add spacing between the table and other content
//         ],
//       );
//     }
//     return pdfLib.Container();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         actions: [
//           IconButton(
//             onPressed: () => _savePdf(context),
//             icon: Icon(Icons.save),
//           ),
//         ],
//       ),
//       drawer: const MainDrawer(),
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/bg1.jpg'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Container(
//             color: Colors.white54.withOpacity(0.45),
//           ),
//           ListView(
//             padding: const EdgeInsets.all(16.0),
//             children: widget.content,
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import '../widgets/main_drawer.dart';
import 'package:open_file/open_file.dart';

class PdfScreen extends StatefulWidget {
  final String title;
  final List<Widget> content;

<<<<<<< HEAD
  const PdfScreen({super.key, required this.title, required this.content});
=======
  const PdfScreen({Key? key, required this.title, required this.content})
      : super(key: key);
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e

  @override
  _PdfScreenState createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  final GlobalKey _globalKey = GlobalKey();
  Uint8List? _imageBytes;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _captureScreenshot() async {
    try {
      // Ensure the widget is rendered before capturing the screenshot
<<<<<<< HEAD
      await Future.delayed(const Duration(milliseconds: 500));
=======
      await Future.delayed(Duration(milliseconds: 500));
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e

      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      setState(() {
        _imageBytes = byteData!.buffer.asUint8List();
      });
    } catch (error) {
      print('Failed to capture screenshot: $error');
    }
  }

  Future<void> _savePdf(BuildContext context) async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await _captureScreenshot();

      final pdfLib.Document pdf = pdfLib.Document();

      pdf.addPage(
        pdfLib.Page(
          pageFormat: PdfPageFormat.a5,
          build: (context) {
            return pdfLib.Center(
              child: pdfLib.Image(pdfLib.MemoryImage(_imageBytes!)),
            );
          },
        ),
      );

      final Directory directory = await getApplicationDocumentsDirectory();
      final String path = '${directory.path}/quotation.pdf';
      final File file = File(path);
      await file.writeAsBytes(await pdf.save());

      OpenFile.open(path);
      print('File saved to: $path');

      ScaffoldMessenger.of(context).showSnackBar(
<<<<<<< HEAD
        const SnackBar(
          content: Text('PDF saved successfully.'),
          duration: Duration(seconds: 2),
=======
        SnackBar(
          content: const Text('PDF saved successfully.'),
          duration: const Duration(seconds: 2),
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
        ),
      );
    } catch (error) {
      print('Failed to save PDF: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save PDF: $error'),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () => _savePdf(context),
            icon: _isSaving
                ? const SizedBox(
                    height: 10,
                    width: 10,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
<<<<<<< HEAD
                : const Icon(Icons.save),
=======
                : Icon(Icons.save),
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: Stack(
        children: [
          Container(
<<<<<<< HEAD
            decoration: const BoxDecoration(
=======
            decoration: BoxDecoration(
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
              image: DecorationImage(
                image: AssetImage('assets/bg1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.white54.withOpacity(0.45),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: RepaintBoundary(
              key: _globalKey,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.content,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
