import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minitaskmanagementapps/presentation/bloc/auth/auth_bloc.dart';
import 'package:minitaskmanagementapps/presentation/bloc/auth/auth_event.dart';
import 'package:minitaskmanagementapps/presentation/bloc/auth/auth_state.dart';

class LoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email')),
                TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password')),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(SignInRequested(
                          emailController.text,
                          passwordController.text,
                        ));
                  },
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(SignUpRequested(
                          emailController.text,
                          passwordController.text,
                        ));
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
