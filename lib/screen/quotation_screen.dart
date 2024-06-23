import 'package:flutter/material.dart';
import '../widgets/create_quotation.dart';
import '../widgets/main_drawer.dart';

class QuotationScreen extends StatelessWidget {
<<<<<<< HEAD
  const QuotationScreen({super.key});
=======
  const QuotationScreen({Key? key}) : super(key: key);
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 105, 172),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Text(
              'Create Quotation',
              style: TextStyle(
                color: Color(0xffffffff),
                fontFamily: 'Roboto',
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.0,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
      drawer: const MainDrawer(),
<<<<<<< HEAD
      body: const QuotationForm(),
=======
      body: QuotationForm(),
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
    );
  }
}
