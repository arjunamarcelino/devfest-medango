import 'package:flutter/material.dart';
import 'package:medan_go/explore.dart';
import 'package:medan_go/homepage.dart';
import 'package:medan_go/planner.dart';
import 'package:medan_go/register.dart';
import 'chatbot.dart';
import 'login.dart';
import 'splash_screen.dart'; // Import the splash screen
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart'; // Add the permission_handler package
import 'package:logger/logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // Load .env file
  await dotenv.load();

  // Request location permission
  await _requestLocationPermission();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

Future<void> _requestLocationPermission() async {
  PermissionStatus status = await Permission.location.request();

  final Logger logger = Logger();

  if (status.isGranted) {
    // If permission is granted, you can proceed with location-dependent functionality
    logger.i("Location permission granted");
  } else if (status.isDenied) {
    // Handle denied case (optional)
    logger.w("Location permission denied");
  } else if (status.isPermanentlyDenied) {
    // Open app settings to allow permissions
    logger.e("Location permission permanently denied");
    openAppSettings();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedanGo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Set the splash screen as the home
      routes: {
        '/home': (context) => const HomePage(), // Home Screen route
        '/planner': (context) => const PlannerPage(), // Planner page route
        '/chatbot': (context) => const ChatbotPage(), // Chatbot page route
        '/explore': (context) => const ExplorePage(), // Explore page route
        '/login': (context) => const LoginPage(), // Login page route
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
