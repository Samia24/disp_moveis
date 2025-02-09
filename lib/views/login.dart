import 'package:flutter/material.dart';
import 'package:projeto_final_allerfree/controllers/login_controllers.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginController _controller = LoginController();


  bool lembrarMe = true;

  void _login() async {
    bool loginSucedido = await _controller.fazerLogin(context);
    if (loginSucedido) {
      Navigator.pushNamed(context, '/mapas');
    }                
  }

  void _cadastrar() {
    Navigator.pushNamed(context, '/cadastro');
  }

  void _esqueceu_senha(){
     Navigator.pushNamed(context, '/esqueceu_senha');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(246, 240, 253, 249),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/images/logo.png', height: 80),
              _iconePerfil(),
              const SizedBox(height: 20),
              _email(),
              const SizedBox(height: 10),
              _senha(),
              _lembrarEsqueceuSenha(),
              _botaoLogin(),
              _botaoCadastrar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconePerfil() {
    return Container(
      padding: const EdgeInsets.all(0.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color.fromARGB(246, 240, 253, 249),
        border: Border.all(color: Colors.red, width: 4),
      ),
      child: const Icon(Icons.person, size: 50, color: Colors.red),
    );
  }

  Widget _email() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: _controller.emailController,
        decoration: _inputDecoration("E-mail", Icons.person),
      ),
    );
  }

  Widget _senha() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        obscureText: true,
        controller: _controller.senhaController,
        decoration: _inputDecoration("Senha", Icons.lock),
      ),
    );
  }

  Widget _lembrarEsqueceuSenha() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                value: lembrarMe,
                onChanged: (value) {
                  setState(() {
                    lembrarMe = value!;
                  });
                },
                checkColor: Colors.white,
                activeColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              const Text("Lembrar-me", style: TextStyle(color: Colors.red, fontSize: 11)),
            ],
          ),
          TextButton(
            onPressed: _esqueceu_senha,
            child: const Text("Esqueceu a senha?",
                style: TextStyle(color: Colors.red, fontSize: 10, decoration: TextDecoration.underline)),
          ),
        ],
      ),
    );
  }

  Widget _botaoLogin() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _login,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Entrar', style: TextStyle(color: Colors.white, fontSize: 15)),
        ),
      ),
    );
  }

  Widget _botaoCadastrar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _cadastrar,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Cadastre-se', style: TextStyle(color: Colors.white, fontSize: 15)),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      prefixIcon: Icon(icon, color: Colors.red),
    );
  }
}
