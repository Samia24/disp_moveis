import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import "../firebase_options.dart";

class EsqueceuSenhaController{
  
  final TextEditingController emailController = TextEditingController();


  void redefinirSenha(BuildContext content) async{
      try {
         await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
         
         print("o email eh: ${emailController.text}");
         print("foi feitro algo");
      } catch (erro) {
         print("erro ao redefinir a senha: ${erro}");
      }
  }

}