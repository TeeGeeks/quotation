import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../base_url.dart';
import './confirmation_code_screen.dart';

class ForgotPasswordPage extends StatefulWidget {
<<<<<<< HEAD
  const ForgotPasswordPage({super.key});

=======
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  // Method to send password reset request to the backend
  Future<void> _submit() async {
    if (_isLoading) {
      return; // Do nothing if already loading
    }

    String email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
<<<<<<< HEAD
        const SnackBar(
=======
        SnackBar(
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
          content: Text('Please enter your email address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse(getBaseUrl('forgot-password')),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate to ConfirmationCodePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmationCodePage(email: email),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Failed to send password reset email. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Stack(
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
            color: Colors.white54
                .withOpacity(0.45), // Adjust the opacity as needed (0.0 - 1.0)
          ),
          Center(
            child: Card(
<<<<<<< HEAD
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
=======
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Forgot your password?',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
<<<<<<< HEAD
                    const SizedBox(height: 16.0),
=======
                    SizedBox(height: 16.0),
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
                    const Text(
                      'Enter the email address associated with your account and we\'ll send you a confirmation code to reset your password.',
                      style: TextStyle(fontSize: 16.0),
                      textAlign: TextAlign.center,
                    ),
<<<<<<< HEAD
                    const SizedBox(height: 24.0),
=======
                    SizedBox(height: 24.0),
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email address';
                        }
                        // You can also add a regex pattern check for email format here if needed
                        return null;
                      },
                    ),
<<<<<<< HEAD
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          const Color.fromARGB(255, 17, 142, 245),
=======
                    SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 17, 142, 245),
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Reset Password',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
