// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/auth/controller/auth_controller.dart';
import 'package:login_screen/auth/screens/sign_up_screen.dart';
import 'package:login_screen/utils/snackbar.dart';
import 'package:login_screen/widgets/gradient_button.dart';
import 'package:login_screen/widgets/loading_indicator.dart';
import 'package:login_screen/widgets/login_field.dart'; // Import your LoginField widget

import 'home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  Future<void> _navigateToSignUp() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupScreen()),
    );
    if (result != null && result is String) {
      emailController.text = result;
      _handleSignIn();
    }
  }

  void _handleSignIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      await ref.read(authControllerProvider.notifier).signIn(email, password);
      _navigateToHome();
    } catch (e) {
      showErrorSnackbar(context, 'User does not exist. Please sign up first.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen<AsyncValue<void>>(authControllerProvider, (_, state) {
      if (state is AsyncError) {
        showErrorSnackbar(context, state.error.toString());
      }
    });

    return Scaffold(
      body: authState is AsyncLoading
          ? const LoadingIndicator()
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Image.asset('assets/images/balls.png'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Sign In',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 380),
                      child: Column(
                        children: [
                          LoginField(
                            hintText: 'Email',
                            onChanged: (value) {
                              emailController.text = value;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          LoginField(
                            hintText: 'Password',
                            obscureText: true,
                            onChanged: (value) {
                              passwordController.text = value;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GradientButton(
                            onPressed: _handleSignIn,
                            label: 'Sign in',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: _navigateToSignUp,
                                child: const Text('Sign Up'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
