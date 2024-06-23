import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../base_url.dart';
import '../get_user.dart';
import './categories_screen.dart';
import './quotation_screen.dart';
import '../widgets/main_drawer.dart';
import '../widgets/price_settings.dart';
import '../widgets/user_profile.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  late List<Map<String, Object>> _pages;
  String _userLogo = '';

  final int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserLogo();
    _pages = [
      {'page': const CategoriesScreen(), 'title': 'Categories'},
      {'page': const QuotationScreen(), 'title': 'Quotations'},
      {'page': const PriceSettings(), 'title': 'Price Settings'},
    ];
  }

  Future<void> _fetchUserLogo() async {
    try {
      String? userId = Provider.of<UserProvider>(context, listen: false).userId;
      String? token = Provider.of<UserProvider>(context, listen: false).token;
      if (userId != null) {
        User? user =
            await UserApi.getUser(userId, token!); // Fetch user details
        if (user != null && user.logo.isNotEmpty) {
          setState(() {
            _userLogo = getBaseUrl(user.logo)
                .replaceAll('\\', '/'); // Ensure URL uses forward slashes
          });
          print('User logo URL: $_userLogo');
        }
      }
    } catch (error) {
      print('Error fetching user logo: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 105, 172),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: SizedBox(
                width: 40, // Adjust the width as needed
                height: 40, // Adjust the height as needed
                child: _userLogo.isNotEmpty
                    ? Image.network(
                        _userLogo,
                        fit: BoxFit
                            .contain, // or BoxFit.fill, BoxFit.contain, etc.
                      )
                    : Container(), // Display user logo if available
              ),
            ),
          ],
        ),
      ),
      drawer: const MainDrawer(),
      body: _pages[_selectedPageIndex]['page'] as Widget,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () => _logout(context),
            backgroundColor: Colors.blue,
            child: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                try {
                  String? token =
                      Provider.of<UserProvider>(context, listen: false).token;

                  if (token != null) {
                    final response = await http.post(
                      Uri.parse(
                          getBaseUrl('logout')), // Update with your server URL
                      headers: {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer $token',
                      },
                    );

                    if (response.statusCode == 200) {
                      // Clear token and navigate to login screen
                      Provider.of<UserProvider>(context, listen: false)
                          .logout();
                      Navigator.pushReplacementNamed(context, '/');
                    } else {
                      // Handle logout failure
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Logout failed. Please try again.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Token is null. Logout failed.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('An error occurred. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
