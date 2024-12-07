import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'auth.dart';
import 'homepage.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false; // Track loading state

  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            isLoading
                ? const CircularProgressIndicator() // Show loading indicator when registering
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading =
                            true; // Start loading when register is pressed
                      });

                      final user =
                          await AuthService().registerWithEmailPassword(
                        emailController.text,
                        passwordController.text,
                      );

                      if (!mounted) {
                        return; // Check if the widget is still in the widget tree
                      }

                      setState(() {
                        isLoading =
                            false; // Stop loading when registration is completed
                      });

                      if (user != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      } else {
                        // Handle registration failure (optional)
                        logger.i("Registration failed");
                      }
                    },
                    child: const Text('Register'),
                  ),
            // Navigate to LoginPage if the user already has an account
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const LoginPage()), // Navigate to LoginPage
                );
              },
              child: const Text('Already have an account? Login here'),
            ),
          ],
        ),
      ),
    );
  }
}
