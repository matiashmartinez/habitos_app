import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/auth_notifier.dart';
import '../../auth/domain/auth_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  

  void _submit() {
    if (formKey.currentState!.validate()) {
      ref.read(authProvider.notifier).login(
            emailController.text.trim(),
            passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (authState is AuthLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

return Scaffold(
  appBar: AppBar(title: const Text("Login")),
  body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (authState is AuthUnauthenticated && authState.message != null)
            Text(
              authState.message!,
              style: const TextStyle(color: Colors.red),
            ),
          const SizedBox(height: 10),

          // EMAIL
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(labelText: "Email"),
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            onFieldSubmitted: (_) => _submit(),
            validator: (value) =>
                value!.isEmpty ? "Ingrese un email" : null,
          ),

          const SizedBox(height: 12),

          // PASSWORD
          TextFormField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: "Password"),
            obscureText: true,
            onFieldSubmitted: (_) => _submit(),
            validator: (value) =>
                value!.isEmpty ? "Ingrese una contraseña" : null,
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: _submit,
            child: const Text("Ingresar"),
          ),
        ],
      ),
    ),
  ),
);
  }
}
