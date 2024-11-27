import 'package:flutter/material.dart';
import 'package:medan_go/homepage.dart';
import 'chatbot.dart';
import 'splash_screen.dart'; // Import the splash screen

void main() {
  runApp(const MyApp());
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
        '/chatbot': (context) => const ChatbotPage(), // Chatbot page route
      },
    );
  }
}
