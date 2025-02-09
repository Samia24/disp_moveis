import 'package:flutter/material.dart';
import '../controllers/esqueceu_senha_controller.dart';

class EsqueceuSenha extends StatefulWidget {
  const EsqueceuSenha({super.key});

  @override
  State<EsqueceuSenha> createState() => _EsqueceuSenhaState();
}

class _EsqueceuSenhaState extends State<EsqueceuSenha> {
  final EsqueceuSenhaController _controller = EsqueceuSenhaController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Redefinir Senha")), // Adicionando um AppBar
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centraliza os widgets
          children: [
            _email(),
            const SizedBox(height: 20), // Espaço entre os elementos
            ElevatedButton(
              onPressed: () => _resetarSenha(context),
              child: const Text("Redefinir senha"),
            )
          ],
        ),
      ),
    );
  }

  void _resetarSenha(BuildContext context) async {
    if (_controller.emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, digite um e-mail válido."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    _controller.redefinirSenha(context);
  }

  Widget _email() {
    return TextField(
      controller: _controller.emailController,
      decoration: _inputDecoration("E-mail", Icons.email),
      keyboardType: TextInputType.emailAddress,
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.red),
      prefixIcon: Icon(icon, color: Colors.red),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
