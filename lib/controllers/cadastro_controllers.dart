import 'package:flutter/material.dart';
import 'package:projeto_final_allerfree/model/banco.dart';

class CadastroController {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController documentoController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController complementoController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  final Banco _banco = Banco();

  Future<void> cadastrarUsuario(BuildContext context) async {
    String nome = nomeController.text;
    String documento = documentoController.text;
    String telefone = telefoneController.text;
    String email = emailController.text;
    String senha = senhaController.text;
    String endereco = enderecoController.text;
    String bairro = bairroController.text;
    String complemento = complementoController.text;
    String cep = cepController.text;
    String cidade = cidadeController.text;
    String estado = estadoController.text;
    String latitude = latitudeController.text;
    String longitude = longitudeController.text;

    if (nome.isNotEmpty &&
        documento.isNotEmpty &&
        telefone.isNotEmpty &&
        email.isNotEmpty &&
        senha.isNotEmpty &&
        endereco.isNotEmpty &&
        bairro.isNotEmpty &&
        complemento.isNotEmpty &&
        cep.isNotEmpty &&
        cidade.isNotEmpty &&
        estado.isNotEmpty &&
        latitude.isNotEmpty &&
        longitude.isNotEmpty) {
      try {
        await _banco.salvarContato(
            nome,
            documento,
            telefone,
            email,
            senha,
            endereco,
            bairro,
            complemento,
            cep,
            cidade,
            estado,
            latitude,
            longitude);

        Navigator.pop(context);
      } catch (e) {
        print("Erro ao cadastrar: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao cadastrar: $e"),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preencha todos os campos!"),
        ),
      );
    }
  }
}
