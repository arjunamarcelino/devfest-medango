import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:medan_go/register.dart';
import 'auth.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false; // Track loading state

  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
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
                ? const CircularProgressIndicator() // Show loading indicator when logging in
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true; // Start loading when login is pressed
                      });

                      final user = await AuthService().signInWithEmailPassword(
                        emailController.text,
                        passwordController.text,
                      );

                      if (!mounted) {
                        return; // Check if the widget is still in the widget tree
                      }

                      setState(() {
                        isLoading =
                            false; // Stop loading when the login is completed
                      });

                      if (user != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      } else {
                        // Handle login failure, show an error, etc.
                        logger.i("Login failed");
                      }
                    },
                    child: const Text('Login'),
                  ),
            isLoading
                ? const SizedBox
                    .shrink() // Don't show the Google login button while loading
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading =
                            true; // Start loading when Google login is pressed
                      });

                      final user = await AuthService().signInWithGoogle();

                      if (!mounted) {
                        return; // Check if the widget is still in the widget tree
                      }

                      setState(() {
                        isLoading =
                            false; // Stop loading when the Google login is completed
                      });

                      if (user != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      } else {
                        // Handle Google login failure, show an error, etc.
                        logger.i("Google Login failed");
                      }
                    },
                    child: const Text('Login with Google'),
                  ),
            // Navigate to RegisterPage
            isLoading
                ? const SizedBox
                    .shrink() // Don't show the Register button while loading
                : TextButton(
                    onPressed: () {
                      // Navigate to RegisterPage without the back button
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    child: const Text('Don\'t have an account? Register here'),
                  ),
          ],
        ),
      ),
    );
  }
}
