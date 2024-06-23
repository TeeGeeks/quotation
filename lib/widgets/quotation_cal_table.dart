import 'package:flutter/material.dart';

class SevenColumnTable extends StatelessWidget {
  final List<Map<String, dynamic>> rowData;

  const SevenColumnTable(
      {super.key, required this.rowData, required Map<String, dynamic> quotationData});

  Widget buildTable() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
        5: FlexColumnWidth(1),
        6: FlexColumnWidth(1),
      },
      border: TableBorder.all(),
      children: [
        TableRow(
          children: [
            TableCell(
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  'Column 1',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  'Column 2',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  'Column 3',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  'Column 4',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  'Column 5',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  'Column 6',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  'Column 7',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        ...rowData.map(
          (data) {
            return TableRow(
              children: [
                TableCell(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(data['col1'].toString()),
                  ),
                ),
                TableCell(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(data['col2'].toString()),
                  ),
                ),
                TableCell(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(data['col3'].toString()),
                  ),
                ),
                TableCell(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(data['col4'].toString()),
                  ),
                ),
                TableCell(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(data['col5'].toString()),
                  ),
                ),
                TableCell(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(data['col6'].toString()),
                  ),
                ),
                TableCell(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(data['col7'].toString()),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildTable();
  }
}
