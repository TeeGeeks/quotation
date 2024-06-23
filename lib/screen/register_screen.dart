import 'package:flutter/material.dart';
import '../get_user.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class CreateAccountPage extends StatefulWidget {
<<<<<<< HEAD
  const CreateAccountPage({super.key});

=======
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyAddressController =
      TextEditingController();
  final TextEditingController _companyWebsiteController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _fileController = TextEditingController();
  bool _isLoading = false;
  static const int maxFileSize = 1 * 1024 * 1024; // 1 MB in bytes

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final file = File(_fileController.text);
      if (file.existsSync() && file.lengthSync() > maxFileSize) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File size should not exceed 1 MB'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true; // Set isLoading to true when form is being submitted
      });
      try {
        await UserApi.createUser(
          companyName: _companyNameController.text,
          companyAddress: _companyAddressController.text,
          companyWebsite: _companyWebsiteController.text,
          username: _usernameController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          password: _passwordController.text,
          filePath: _fileController.text,
        );

        // User created successfully
        // Reset the form
        _formKey.currentState!.reset();

        // Show a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User created successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Delay for a short duration before navigating to the login page
        await Future.delayed(const Duration(seconds: 1));

        // Navigate to the login page
        Navigator.pushReplacementNamed(context, '/');
      } catch (error) {
        String errorMessage =
            'Failed to create user: Email or Username already exits';
        // if (error is ApiException) {
        //   errorMessage = error.message;
        // }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading =
              false; // Set isLoading back to false after submission is complete
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
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
            color: Colors.white54.withOpacity(0.45),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    _buildTextFormField(
                      controller: _companyNameController,
                      labelText: 'Company Name',
                      isRequired: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your company name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    _buildTextFormField(
                      controller: _companyAddressController,
                      labelText: 'Company Address',
                      isRequired: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your company address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    _buildTextFormField(
                      controller: _companyWebsiteController,
                      labelText: 'Company Website',
                    ),
                    const SizedBox(height: 16.0),
                    _buildTextFormField(
                      controller: _usernameController,
                      labelText: 'Username',
                      isRequired: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    _buildTextFormField(
                      controller: _phoneController,
                      labelText: 'Phone Number',
                      isRequired: true,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    _buildFilePickerFormField(),
                    const SizedBox(height: 16.0),
                    _buildTextFormField(
                      controller: _emailController,
                      labelText: 'Email',
                      isRequired: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    _buildTextFormField(
                      controller: _passwordController,
                      labelText: 'Password',
                      isRequired: true,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        } else if (value.length <= 6) {
                          return 'Password must be more than 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    _buildTextFormField(
                      controller: _confirmPasswordController,
                      labelText: 'Confirm Password',
                      isRequired: true,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        } else if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _submitForm();
                          }
                        },
                        style: ButtonStyle(
<<<<<<< HEAD
                          backgroundColor: WidgetStateProperty.all<Color>(
=======
                          backgroundColor: MaterialStateProperty.all<Color>(
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
                            const Color.fromARGB(255, 17, 142, 245),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Create Account',
                                style: TextStyle(color: Colors.white),
                              ),
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

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        label: isRequired
            ? RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: labelText,
<<<<<<< HEAD
                      style: const TextStyle(color: Colors.black),
                    ),
                    const TextSpan(
=======
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              )
            : Text(labelText),
<<<<<<< HEAD
        border: const OutlineInputBorder(),
=======
        border: OutlineInputBorder(),
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
    );
  }

  Widget _buildFilePickerFormField() {
    return TextFormField(
      controller: _fileController,
      decoration: InputDecoration(
        label: RichText(
<<<<<<< HEAD
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Select Logo',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
=======
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Select Logo',
                style: TextStyle(color: Colors.black),
              ),
              const TextSpan(
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
<<<<<<< HEAD
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.attach_file),
=======
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(Icons.attach_file),
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();
            if (result != null) {
              final file = File(result.files.single.path!);
              if (file.existsSync() && file.lengthSync() > maxFileSize) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('File size should not exceed 1 MB'),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                setState(() {
                  _fileController.text = result.files.single.path!;
                });
              }
            }
          },
        ),
      ),
      readOnly: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a file';
        }
        return null;
      },
    );
  }
}
