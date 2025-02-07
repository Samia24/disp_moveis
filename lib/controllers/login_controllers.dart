import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  Future<bool> fazerLogin(BuildContext context) async {
    String email = emailController.text;
    String senha = senhaController.text;

    //Verifica se os campos não estão vazios
    if (email.isNotEmpty && senha.isNotEmpty) {
      try {
        //Faz uma consulta no banco, verificando se esses dados constam
        QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('banco')
          .where('email', isEqualTo: email)
          .where('senha', isEqualTo: senha)
          .get();

        //Se esse documento/contato existir, login com sucesso
        if (snapshot.docs.isNotEmpty) {
          return true; // Login bem-sucedido
        } else {
          // Exibe mensagem de erro
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Usuário e/ou senha inválidos!"),
            ),
          );
          return false; // Login falhou
        }
      } catch (e) {
        //Se houver algum problema durante o login, como por ex erro de conexão, ele emite o erro
        print("Erro ao fazer login: $e");
        // Exibe mensagem de erro para o usuário
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao fazer login: $e"),
          ),
        );
        return false; // Login falhou
      }
    } else {
      // Exibe mensagem de erro se algum campo estiver vazio
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preencha todos os campos!"),
        ),
      );
      return false; // Login falhou
    }
  }
}