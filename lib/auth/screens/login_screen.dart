// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/auth/controller/auth_controller.dart';
import 'package:login_screen/auth/screens/sign_up_screen.dart';
import 'package:login_screen/utils/snackbar.dart';
import 'package:login_screen/widgets/loading_indicator.dart';

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
      appBar: AppBar(title: const Text('Login')),
      body: authState is AsyncLoading
          ? const LoadingIndicator()
          : Padding(
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
                  ElevatedButton(
                    onPressed: _handleSignIn,
                    child: const Text('Login'),
                  ),
                  TextButton(
                    onPressed: _navigateToSignUp,
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ),
    );
  }
}
