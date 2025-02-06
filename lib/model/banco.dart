import 'package:cloud_firestore/cloud_firestore.dart';

class Banco {
  final CollectionReference bancoCollection =
      FirebaseFirestore.instance.collection('banco');

  Future<void> salvarContato(
      String nome,
      String documento,
      String telefone,
      String email,
      String senha,
      String endereco,
      String bairro,
      String complemento,
      String cep,
      String cidade,
      String estado,
      String latitude,
      String longitude) async {
    try {
      await bancoCollection.add({
        'nome': nome,
        'documento': documento,
        'telefone': telefone,
        'email': email,
        'senha': senha,
        'endereco': endereco,
        'bairro': bairro,
        'complemento': complemento,
        'cep': cep,
        'cidade': cidade,
        'estado': estado,
        'latitude': latitude,
        'longitude': longitude,
      });
    } catch (e) {
      print("Erro ao salvar contato: $e");
    }
  }
}
