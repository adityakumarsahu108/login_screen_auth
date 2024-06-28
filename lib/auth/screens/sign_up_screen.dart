import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/auth/controller/auth_controller.dart';
import 'package:login_screen/utils/snackbar.dart';
import 'package:login_screen/widgets/loading_indicator.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _navigateToLogin(BuildContext context, String email) {
    Navigator.pop(context, email);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen<AsyncValue<void>>(authControllerProvider, (_, state) {
      if (state is AsyncError) {
        showErrorSnackbar(context, state.error.toString());
      } else if (state is AsyncData) {
        showSuccessSnackbar(context, "Sign up successful! Please log in.");
        _navigateToLogin(context, emailController.text.trim());
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
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
                    onPressed: () async {
                      await ref.read(authControllerProvider.notifier).signUp(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ),
    );
  }
}
