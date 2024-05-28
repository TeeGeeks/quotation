import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:quotation_app/base_url.dart';
import 'package:quotation_app/get_user.dart';
import 'package:quotation_app/screen/categories_screen.dart';
import 'package:quotation_app/screen/quotation_screen.dart';
import 'package:quotation_app/widgets/main_drawer.dart';
import 'package:quotation_app/widgets/price_settings.dart';
import 'package:quotation_app/widgets/user_profile.dart';

class TabsScreen extends StatefulWidget {
  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  late List<Map<String, Object>> _pages;
  String _userLogo = '';

  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserLogo();
    _pages = [
      {'page': const CategoriesScreen(), 'title': 'Categories'},
      {'page': const QuotationScreen(), 'title': 'Quotations'},
      {'page': PriceSettings(), 'title': 'Price Settings'},
    ];
  }

// http://localhost:5000/uploads/file-1716300680886.jpg
// http://192.168.137.210:5000/uploads/file-1716300680886.jpg
  Future<void> _fetchUserLogo() async {
    try {
      String? userId = Provider.of<UserProvider>(context, listen: false).userId;
      if (userId != null) {
        User? user = await UserApi.getUser(userId); // Fetch user details
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
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
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
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
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
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
