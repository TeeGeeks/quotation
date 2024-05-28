import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotation_app/authService.dart';
import 'package:quotation_app/delete_quotation.dart';
import 'package:quotation_app/quotations.dart';
import 'package:quotation_app/screen/edit_quotation_screen.dart';
import 'package:quotation_app/screen/forgot_pass.dart';
import 'package:quotation_app/screen/login_screen.dart';
import 'package:quotation_app/screen/product_items_screen.dart';
import 'package:quotation_app/screen/quotation_screen.dart';
import 'package:quotation_app/screen/register_screen.dart';
import 'package:quotation_app/screen/reset_pass.dart';
import 'package:quotation_app/screen/tabs_screen.dart';
import 'package:quotation_app/widgets/main_drawer.dart';
import 'package:quotation_app/widgets/price_settings.dart';
import 'package:quotation_app/widgets/about.dart';
import 'package:quotation_app/widgets/user_profile.dart';
import 'package:quotation_app/screen/user_profile_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quotation App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 23, 105, 172),
            foregroundColor: Colors.white,
          ),
          textTheme: ThemeData.light().textTheme.copyWith(
                bodyLarge:
                    const TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
                bodyMedium:
                    const TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
                titleMedium: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
        initialRoute: '/splash',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/splash':
              return MaterialPageRoute(builder: (_) => SplashScreen());
            case '/':
              return MaterialPageRoute(
                  builder: (_) => Scaffold(
                        drawer: const MainDrawer(),
                        body: LoginPage(),
                      ));
            case '/register':
              return MaterialPageRoute(
                  builder: (_) => Scaffold(
                        body: CreateAccountPage(),
                      ));
            case '/forgot_password':
              return MaterialPageRoute(
                  builder: (_) => Scaffold(
                        body: ForgotPasswordPage(),
                      ));
            case '/home':
              return MaterialPageRoute(builder: (context) {
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                if (userProvider.token != null) {
                  return Scaffold(
                    drawer: const MainDrawer(),
                    body: TabsScreen(),
                  );
                } else {
                  return LoginPage(); // Redirect to login if not authenticated
                }
              });
            case '/create-quotation':
              return MaterialPageRoute(builder: (context) {
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                if (userProvider.token != null) {
                  return const Scaffold(
                    drawer: MainDrawer(),
                    body: QuotationScreen(),
                  );
                } else {
                  return LoginPage(); // Redirect to login if not authenticated
                }
              });
            case '/products':
              return MaterialPageRoute(builder: (context) {
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                if (userProvider.token != null) {
                  return const Scaffold(
                    drawer: MainDrawer(),
                    body: ProductItemsScreen(),
                  );
                } else {
                  return LoginPage(); // Redirect to login if not authenticated
                }
              });
            case '/quotations':
              return MaterialPageRoute(builder: (context) {
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                if (userProvider.token != null) {
                  return Scaffold(
                    drawer: const MainDrawer(),
                    body: AllQuotationScreen(),
                  );
                } else {
                  return LoginPage(); // Redirect to login if not authenticated
                }
              });
            case '/price_settings':
              return MaterialPageRoute(builder: (context) {
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                if (userProvider.token != null) {
                  return Scaffold(
                    drawer: const MainDrawer(),
                    body: PriceSettings(),
                  );
                } else {
                  return LoginPage(); // Redirect to login if not authenticated
                }
              });
            case '/delete_quotation':
              return MaterialPageRoute(builder: (context) {
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                if (userProvider.token != null) {
                  return Scaffold(
                    drawer: const MainDrawer(),
                    body: DeleteScreen(),
                  );
                } else {
                  return LoginPage(); // Redirect to login if not authenticated
                }
              });
            case '/edit_quotation':
              return MaterialPageRoute(builder: (context) {
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                if (userProvider.token != null) {
                  return Scaffold(
                    drawer: const MainDrawer(),
                    body: EditScreen(),
                  );
                } else {
                  return LoginPage(); // Redirect to login if not authenticated
                }
              });
            case '/profile':
              return MaterialPageRoute(builder: (context) {
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                if (userProvider.token != null) {
                  return Scaffold(
                    drawer: const MainDrawer(),
                    body: UserProfileScreen(
                      userId: userProvider.userId!,
                    ),
                  );
                } else {
                  return LoginPage(); // Redirect to login if not authenticated
                }
              });
               case '/about-us':
              return MaterialPageRoute(builder: (context) {
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                if (userProvider.token != null) {
                  return Scaffold(
                    drawer: const MainDrawer(),
                    body: AboutPage(),
                  );
                } else {
                  return LoginPage(); // Redirect to login if not authenticated
                }
              });
            default:
              return MaterialPageRoute(
                  builder: (_) => Scaffold(
                        body: Center(
                          child: Text('Unknown route: ${settings.name}'),
                        ),
                      ));
          }
        },
      ),
    ),
  );
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    _animationController.forward();

    // Call _checkTokenValidity() function immediately after 5 seconds delay
    Timer(const Duration(seconds: 5), _checkTokenValidity);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Function to check token validity
  Future<void> _checkTokenValidity() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? token = userProvider.token;
    if (token != null) {
      final isTokenExpired = await AuthService.isTokenExpired(token);
      if (isTokenExpired) {
        // Token expired, navigate to login screen
        Navigator.of(context).pushReplacementNamed('/');
      } else {
        // Token valid and user already authenticated, navigate to home screen
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } else {
      // Token not available, navigate to login screen
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg1.jpg'), // Background image
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent, // Make scaffold transparent
          body: Center(
            child: FadeTransition(
              opacity: _animation,
              child: ScaleTransition(
                scale: _animation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      width: 200,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Quotation App',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // CircularProgressIndicator(
                    //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
