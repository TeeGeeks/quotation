import 'package:flutter/material.dart';
import './main_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutPage extends StatelessWidget {
<<<<<<< HEAD
  const AboutPage({super.key});

=======
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
<<<<<<< HEAD
        backgroundColor: const Color.fromARGB(255, 23, 105, 172),
=======
        backgroundColor: Color.fromARGB(255, 23, 105, 172),
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
      ),
      drawer: const MainDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/logo.png',
                  width: 150,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to the Quotation App from Evans Brothers (Nig Publishers) Limited!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 23, 105, 172),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Version: 1.0.0',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'About Evans Brothers (Nig Publishers) Limited:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 23, 105, 172),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Evans Brothers (Nig Publishers) Limited is a leading educational publisher in Nigeria, committed to providing high-quality educational materials to students and educators across the country. With a rich history spanning several decades, Evans Brothers is dedicated to promoting literacy and excellence in education.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Contact Us:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 23, 105, 172),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Address: 2, Jericho Road, P.M.B. 5164, Ibadan, Oyo State, Nigeria.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Email: info@evanspublishers.com',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Phone: +234 803 303 6713',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Follow Us:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 23, 105, 172),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      // Add functionality for Facebook
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.facebook,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: () {
                      // Add functionality for Twitter
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.twitter,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                      // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
<<<<<<< HEAD
                      icon: const FaIcon(FontAwesomeIcons.gamepad),
=======
                      icon: FaIcon(FontAwesomeIcons.gamepad),
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
                      onPressed: () {
                        print("Pressed");
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
<<<<<<< HEAD
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

=======
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'About Page - Quotation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
<<<<<<< HEAD
      home: const AboutPage(),
=======
      home: AboutPage(),
>>>>>>> 9e121ec21b8d23bed6153051a36251918372cd4e
    );
  }
}
