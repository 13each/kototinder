import 'package:flutter/material.dart';

import 'auth_controller.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
    required this.controller,
    required this.onAuthenticated,
  });

  final AuthController controller;
  final VoidCallback onAuthenticated;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    final success = await widget.controller.submit(
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      widget.onAuthenticated();
      return;
    }

    final error = widget.controller.errorMessage;
    if (error != null && error.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  void _switchMode(AuthMode mode) {
    widget.controller.switchMode(mode);
    _formKey.currentState?.reset();
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final mode = widget.controller.mode;
        final isSignUp = mode == AuthMode.signUp;

        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome to Kototinder',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SegmentedButton<AuthMode>(
                              segments: const [
                                ButtonSegment(
                                  value: AuthMode.signIn,
                                  label: Text('Sign in'),
                                  icon: Icon(Icons.login_rounded),
                                ),
                                ButtonSegment(
                                  value: AuthMode.signUp,
                                  label: Text('Sign up'),
                                  icon: Icon(Icons.person_add_alt_1_rounded),
                                ),
                              ],
                              selected: {mode},
                              onSelectionChanged: (selection) {
                                _switchMode(selection.first);
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              key: const Key('emailField'),
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                              validator: widget.controller.validateEmail,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              key: const Key('passwordField'),
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(),
                              ),
                              validator: widget.controller.validatePassword,
                            ),
                            if (isSignUp) ...[
                              const SizedBox(height: 14),
                              TextFormField(
                                key: const Key('confirmField'),
                                controller: _confirmPasswordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Confirm password',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  return widget.controller
                                      .validateConfirmPassword(
                                        _passwordController.text,
                                        value,
                                      );
                                },
                              ),
                            ],
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                key: const Key('submitButton'),
                                onPressed: widget.controller.isLoading
                                    ? null
                                    : _submit,
                                child: widget.controller.isLoading
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        isSignUp ? 'Create account' : 'Sign in',
                                      ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              key: const Key('toggleModeButton'),
                              onPressed: () {
                                _switchMode(
                                  isSignUp ? AuthMode.signIn : AuthMode.signUp,
                                );
                              },
                              child: Text(
                                isSignUp
                                    ? 'Already have an account? Sign in'
                                    : "Don't have an account? Sign up",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
