import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/auth/controller/auth_controller.dart';
import 'package:login_screen/utils/snackbar.dart';
import 'package:login_screen/widgets/gradient_button.dart';
import 'package:login_screen/widgets/loading_indicator.dart';
import 'package:login_screen/widgets/login_field.dart';

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

  void _navigateToSignIn(BuildContext context) {
    Navigator.pop(context);
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
      body: authState is AsyncLoading
          ? const LoadingIndicator()
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Image.asset('assets/images/balls.png'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Sign Up',
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
                            onPressed: () async {
                              await ref
                                  .read(authControllerProvider.notifier)
                                  .signUp(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                  );
                            },
                            label: 'Sign Up',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => _navigateToSignIn(context),
                                child: const Text('Sign In'),
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
