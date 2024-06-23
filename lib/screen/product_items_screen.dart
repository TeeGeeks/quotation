import 'package:flutter/material.dart';
import '../dummy_data.dart';
import '../model/product.dart';
import '../widgets/main_drawer.dart';
import '../widgets/product_item.dart';

class ProductItemsScreen extends StatelessWidget {
<<<<<<< HEAD
  const ProductItemsScreen({super.key});
=======
  const ProductItemsScreen({Key? key}) : super(key: key);
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
                'Products',
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
          GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: DUMMY_PRODUCT.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemBuilder: (ctx, i) {
              Product product = DUMMY_PRODUCT[i];
              return ProductItem(
                id: product.id,
                title: product.title,
                description: product.description,
                imageUrl: product.imageUrl,
              );
            },
          ),
        ]));
  }
}
