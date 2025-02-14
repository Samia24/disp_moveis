import 'package:flutter/material.dart';

class StoreDetailsScreen extends StatefulWidget {
  final String nome;
  final String endereco;
  final String telefone;
  final String horario;
  final List<Map<String, dynamic>> produtos;

  const StoreDetailsScreen({
    super.key,
    required this.nome,
    required this.endereco,
    required this.telefone,
    required this.horario,
    required this.produtos,
  });

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(246, 240, 253, 249),
      appBar: AppBar(
        title: Text(widget.nome, style: TextStyle(color: const Color.fromARGB(246, 240, 253, 249))),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exibindo os detalhes da loja diretamente
            _buildInfoRow(Icons.location_on, 'Endereço', widget.endereco),
            _buildInfoRow(Icons.phone, 'Telefone', widget.telefone),
            _buildInfoRow(Icons.access_time, 'Horário', widget.horario),

            const SizedBox(height: 20),

            // Botão para redirecionar para os produtos
            ElevatedButton(
              onPressed: () {
                _showProductPage();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'Ver Produtos',
                style: TextStyle(color: Color.fromARGB(246, 240, 253, 249),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para exibir os detalhes sem precisar de interação
  Widget _buildInfoRow(IconData icon, String label, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  text,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Método para redirecionar para a tela de produtos
  void _showProductPage() {
    if (widget.produtos.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductPage(produtos: widget.produtos),
        ),
      );
    } else {
      // Mostra uma mensagem caso não haja produtos
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum produto disponível.')),
      );
    }
  }
}

class ProductPage extends StatelessWidget {
  final List<Map<String, dynamic>> produtos;

  const ProductPage({super.key, required this.produtos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos', style: TextStyle(color:  Color.fromARGB(246, 240, 253, 249)),),
        backgroundColor: Colors.red,
      ),
      body: produtos.isEmpty
          ? const Center(child: Text('Nenhum produto disponível'))
          : ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final produto = produtos[index];
                return Card(
                  color: const Color.fromARGB(246, 240, 253, 249),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Image.network(
                      produto['imagem'],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported),
                    ),
                    title: Text(produto['nome']),
                    subtitle: Text('R\$ ${produto['preco'].toStringAsFixed(2)}'),
                  ),
                );
              },
            ),
    );
  }
}