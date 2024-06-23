import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  Widget buildListTile(String title, IconData icon, VoidCallback? tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
        color: Colors.black,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          MediaQuery.of(context).size.width * 0.6, // Adjust the width as needed
      child: Drawer(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              color: Colors.white54.withOpacity(
                  0.45), // Adjust the opacity as needed (0.0 - 1.0)
            ),
            Column(
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.centerLeft,
                  color: Colors.blue,
                  child: const Text(
                    'Quotation App',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Divider(),
                buildListTile('Home', Icons.home, () {
                  Navigator.of(context).pushReplacementNamed('/home');
                }),
                const Divider(),
                buildListTile('Quotation', Icons.note_add, () {
                  Navigator.of(context)
                      .pushReplacementNamed('/create-quotation');
                }),
                const Divider(),
                buildListTile('Products', Icons.shopping_cart, () {
                  Navigator.of(context).pushReplacementNamed('/products');
                }),
                const Divider(),
                buildListTile('Reports', Icons.receipt, () {
                  Navigator.of(context).pushReplacementNamed('/quotations');
                }),
                const Divider(),
                buildListTile('Price Settings', Icons.settings, () {
                  Navigator.of(context).pushReplacementNamed('/price_settings');
                }),
                const Divider(),
                buildListTile('Profile', Icons.account_circle, () {
                  Navigator.of(context).pushReplacementNamed('/profile');
                }),
                const Divider(),
                buildListTile('About', Icons.info, () {
                  Navigator.of(context).pushReplacementNamed('/about-us');
                }),
                const Divider(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
