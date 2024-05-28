import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotation_app/base_url.dart';
import 'package:quotation_app/widgets/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoggingIn = false;

  void _submit() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    setState(() {
      _isLoggingIn = true; // Disable the login button
    });

    try {
      var response = await http.post(
        Uri.parse(getBaseUrl('login')),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Successful login
        Map<String, dynamic> responseData = jsonDecode(response.body);
        String token = responseData['token'];
        String userId = responseData['userId'];

        print('Token received: $token'); // Check if the token is received

        // Save the token and userId to the UserProvider
        Provider.of<UserProvider>(context, listen: false).login(token, userId);

        // Save email and password in SharedPreferences if rememberMe is true
        if (_rememberMe) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', email);
          await prefs.setString('password', password);
        }

        // Navigate to the home screen
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Display a SnackBar if login fails
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed. Please check your credentials.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Display a SnackBar if an error occurs during login
      print('Error during login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred during login. Network error!'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoggingIn = false; // Enable the login button
      });
    }
  }

  void _loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      final response = await http.post(
        Uri.parse(getBaseUrl('googleSignIn')),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'googleIdToken': idToken}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        // Handle successful Google sign-in response
        print('Google sign-in successful: $responseData');
      } else {
        throw Exception('Failed to sign in with Google');
      }
    } catch (e) {
      print('Error during Google sign-in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'An error occurred during Google sign-in. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');
    if (email != null && password != null) {
      setState(() {
        _emailController.text = email;
        _passwordController.text = password;
        _rememberMe = true;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.0), // Remove app bar
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: null,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Image.asset(
              'assets/bg.jpg',
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/logo.png',
                      width: 80.0,
                      height: 80.0,
                    ),
                    const SizedBox(height: 24.0),
                    const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24.0),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.black54, // Change the color here
                        ),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.black54, // Change the color here
                        ),
                      ),
                      obscureText: true,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (bool? value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          activeColor: Colors.blue, // Border color when checked
                          checkColor: Colors.white, // Check color when checked
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (states) {
                            if (states.contains(MaterialState.selected)) {
                              return Colors
                                  .blue; // Background color when checked
                            }
                            return Colors
                                .transparent; // Background color when unchecked
                          }),
                          side: BorderSide(
                            color: _rememberMe
                                ? Colors.blue
                                : Colors.white, // Border color
                            width: 2.0, // Border width
                          ),
                        ),
                        const Text('Remember Me',
                            style: TextStyle(color: Colors.white)),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot_password');
                            // Implement Forgot Password logic
                          },
                          child: const Text('Forgot Password?',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 12),
                        ),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.blue, // Set the background color
                        ),
                        foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white, // Set the text color
                        ),
                      ),
                      child: _isLoggingIn
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Login'),
                    ),
                    const SizedBox(height: 6.0),
                    OutlinedButton(
                      onPressed: _loginWithGoogle,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        side: const BorderSide(color: Colors.white),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/google.png', height: 24.0),
                          const SizedBox(width: 12.0),
                          const Text('Login with Google',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                          "Don't have an account? Create Account!",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
