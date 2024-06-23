import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../base_url.dart';
import './reset_pass.dart';

class ConfirmationCodePage extends StatefulWidget {
  final String email;

<<<<<<< HEAD
  const ConfirmationCodePage({super.key, required this.email});
=======
  ConfirmationCodePage({required this.email});
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e

  @override
  State<ConfirmationCodePage> createState() => _ConfirmationCodePageState();
}

class _ConfirmationCodePageState extends State<ConfirmationCodePage> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;

  // Method to verify the confirmation code
  Future<void> _verifyCode() async {
    if (_isLoading) {
      return; // Do nothing if already loading
    }

    String code = _codeController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
<<<<<<< HEAD
        const SnackBar(
=======
        SnackBar(
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
          content: Text('Please enter the confirmation code'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Perform API request to verify the code
      var response = await http.post(
        Uri.parse(getBaseUrl('verify-code')),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'email': widget.email, 'code': code}),
      );

      if (response.statusCode == 200) {
        // Navigate to ResetPasswordPage if verification is successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ResetPasswordPage(email: widget.email, code: code),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid confirmation code. Please try again.'),
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
          title: const Text('Enter Confirmation Code'),
        ),
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
                      'Enter the confirmation code',
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
                      'Please check your email for the confirmation code we sent you.',
                      style: TextStyle(fontSize: 16.0),
                      textAlign: TextAlign.center,
                    ),
<<<<<<< HEAD
                    const SizedBox(height: 24.0),
=======
                    SizedBox(height: 24.0),
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
                    TextFormField(
                      controller: _codeController,
                      decoration: const InputDecoration(
                        labelText: 'Confirmation Code',
                        hintText: 'Enter the confirmation code',
                      ),
                      keyboardType: TextInputType.number,
                    ),
<<<<<<< HEAD
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: _verifyCode,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          const Color.fromARGB(255, 17, 142, 245),
=======
                    SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: _verifyCode,
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
                              'Verify Code',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]));
  }
}
