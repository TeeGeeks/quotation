import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String imageUrl;

  const ProductItem({
<<<<<<< HEAD
    super.key,
=======
    Key? key,
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
<<<<<<< HEAD
  });
=======
  }) : super(key: key);
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e

  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: GridTileBar(
        backgroundColor: Colors.black54,
        title: Text(title, textAlign: TextAlign.center),
      ),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
