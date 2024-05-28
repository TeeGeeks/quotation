import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  Widget _buildDashboardTile(BuildContext context, String title, IconData icon,
      Color color, String routeName) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(routeName);
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(.5), color.withOpacity(.6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            const Color.fromARGB(255, 102, 86, 145)
                .withOpacity(0.6), // Adjust opacity here
            BlendMode.srcOver,
          ),
          child: Image.asset(
            'assets/bg.jpg', // Path to your background image file
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        GridView.count(
          padding: const EdgeInsets.all(20),
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _buildDashboardTile(context, 'Make Quotation', Icons.note_add,
                Colors.green, '/create-quotation'),
            _buildDashboardTile(
                context, 'Report', Icons.receipt, Colors.blue, '/quotations'),
            _buildDashboardTile(context, 'Price Setting', Icons.attach_money,
                Colors.orange, '/price_settings'),
            _buildDashboardTile(context, 'Products', Icons.shopping_cart,
                Colors.purple, '/products'),
            _buildDashboardTile(context, 'Edit Quotation', Icons.edit,
                Colors.teal, '/edit_quotation'),
            _buildDashboardTile(context, 'Delete Quotation', Icons.delete,
                Colors.red, '/delete_quotation'),
          ],
        ),
      ],
    );
  }
}
