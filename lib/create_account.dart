import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA61E22),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Text(
                "Create\nAccount",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Already Registered? Log in here.",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 32),
              buildTextField(nameController, "Full Name"),
              const SizedBox(height: 16),
              buildTextField(emailController, "Email"),
              const SizedBox(height: 16),
              buildTextField(phoneController, "Mobile Number"),
              const SizedBox(height: 16),
              buildTextField(districtController, "Address"),
              const SizedBox(height: 16),
              buildTextField(bloodGroupController, "Blood Group"),
              const SizedBox(height: 16),
              buildTextField(
                passwordController,
                "Password",
                obscureText: !_isPasswordVisible,
                isPassword: true,
              ),
              const SizedBox(height: 16),
              buildTextField(
                confirmPasswordController,
                "Confirm Password",
                obscureText: !_isConfirmPasswordVisible,
                isConfirmPassword: true,
              ),
              const SizedBox(height: 32),

              // ✅ Sign Up Button wrapped in Builder for proper context
              Builder(
                builder: (contextButton) => SizedBox(
                  width: 160,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF3E9E9),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () async {
                      print("Sign Up button clicked");

                      if (passwordController.text != confirmPasswordController.text) {
                        ScaffoldMessenger.of(contextButton).showSnackBar(
                          const SnackBar(content: Text("Passwords do not match")),
                        );
                        return;
                      }

                      String email = emailController.text.trim();
                      String password = passwordController.text.trim();

                      try {
                        // Try to create a new user
                        UserCredential userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(email: email, password: password);

                        print("User created: ${userCredential.user!.email}");

                        // Save extra info to Firestore
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userCredential.user!.uid)
                            .set({
                          'name': nameController.text.trim(),
                          'email': email,
                          'phone': phoneController.text.trim(),
                          'district': districtController.text.trim(),
                          'bloodGroup': bloodGroupController.text.trim(),
                        });
                      } on FirebaseAuthException catch (e) {
                        print("FirebaseAuthException: ${e.code}");

                        if (e.code == 'email-already-in-use') {
                          // Existing user → sign in
                          try {
                            UserCredential userCredential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(email: email, password: password);
                            print("Signed in existing user: ${userCredential.user!.email}");
                          } on FirebaseAuthException catch (e) {
                            print("Sign in failed: ${e.message}");
                            ScaffoldMessenger.of(contextButton).showSnackBar(
                              SnackBar(content: Text("Sign in failed: ${e.message}")),
                            );
                            return;
                          }
                        } else {
                          ScaffoldMessenger.of(contextButton).showSnackBar(
                            SnackBar(content: Text("Error: ${e.message}")),
                          );
                          return;
                        }
                      } catch (e) {
                        print("Other error: $e");
                        ScaffoldMessenger.of(contextButton).showSnackBar(
                          SnackBar(content: Text("Error: $e")),
                        );
                        return;
                      }

                      // ✅ Navigate to HomePage
                      print("Navigating to HomePage...");
                      Navigator.pushReplacement(
                        contextButton,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                      );
                    },
                    child: const Text("Sign up"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      TextEditingController controller,
      String hint, {
        bool obscureText = false,
        bool isPassword = false,
        bool isConfirmPassword = false,
      }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF3E9E9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        )
            : isConfirmPassword
            ? IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        )
            : null,
      ),
    );
  }
}