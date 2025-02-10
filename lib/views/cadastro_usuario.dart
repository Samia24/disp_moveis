import 'package:flutter/material.dart';
import 'package:projeto_final_allerfree/controllers/cadastro_controllers.dart';

class CadastroUsuario extends StatefulWidget {
  const CadastroUsuario({super.key});

  @override
  State<CadastroUsuario> createState() => _CadastroUsuarioState();
}

bool usuarioAtivado = true; // true para pessoa, false para loja

class _CadastroUsuarioState extends State<CadastroUsuario> {
  
  final CadastroController _controller = CadastroController();

  void _finalizarCadastro () async {
    await _controller.cadastrarUsuario(context);
    Navigator.pushNamed(context, '/login');
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(246, 240, 253, 249),
          foregroundColor: Colors.red,
          shadowColor: Colors.red,
          title: const Text("Cadastro",
              style: TextStyle(
                  fontFamily: 'Satisfy', color: Colors.red, fontSize: 34)),
        ),
        backgroundColor: const Color.fromARGB(246, 240, 253, 249),
        body: Column(
          children: [
            // Identificação vem primeiro
            _identificacao(),

            // TabBar logo abaixo da identificação
            TabBar(
              labelColor: Colors.red,
              indicatorColor: Colors.red,
              tabs: [
                const Tab(icon: Icon(Icons.person), text: "Contato"),
                const Tab(icon: Icon(Icons.location_on), text: "Endereço"),
                usuarioAtivado
                    ? Tab(icon: Icon(Icons.payment), text: "Pagamento")
                    : Tab(icon: Icon(Icons.pix), text: "PIX"),
              ],
            ),

            // TabBarView que alterna entre Pagamento e Pix
            Expanded(
              child: TabBarView(
                children: [
                  _contatoTab(),
                  _enderecoTab(),
                  usuarioAtivado ? _pagamentoTab() : _pixTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _identificacao() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Identifique-se:",
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                usuarioAtivado = true;
              });
            },
            icon: Icon(Icons.person_outlined,
                color: usuarioAtivado ? Colors.red : Colors.grey),
          ),
          Switch(
            value: !usuarioAtivado,
            onChanged: (value) {
              setState(() {
                usuarioAtivado = !value;
              });
            },
            activeColor: Colors.red,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey[300],
          ),
          IconButton(
            onPressed: () {
              setState(() {
                usuarioAtivado = false;
              });
            },
            icon: Icon(Icons.store_outlined,
                color: !usuarioAtivado ? Colors.red : Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _contatoTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
        child: Column(
          children: [
            usuarioAtivado
                ? TextFormField(
                    controller: _controller.nomeController,
                    decoration: _inputDecoration("Nome", "Informe seu nome completo"),
                  )
                : TextFormField(
                    controller: _controller.nomeController,
                    decoration: _inputDecoration("Razão Social/Nome fantasia", "Nome da sua loja"),
                  ),
            const SizedBox(height: 10),
            usuarioAtivado
                ? TextFormField(
                    controller: _controller.documentoController,
                    decoration: _inputDecoration("CPF", "xxx.xxx.xxx-xx"),
                  )
                : TextFormField(
                    controller: _controller.documentoController,
                    decoration: _inputDecoration("CNPJ", "xx.xxx.xxx/xxxx-xx"),
                  ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _controller.telefoneController,
              decoration: _inputDecoration("Telefone", "(xx) x xxxx-xxxx"),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _controller.emailController,
              decoration: _inputDecoration("E-mail", "email@gmail.com"),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _controller.senhaController,
              decoration: _inputDecoration("Senha", "Senha de 4 dígitos"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _enderecoTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
        child: Column(
          children: [
            usuarioAtivado
                ? TextFormField(
                    controller: _controller.enderecoController,
                    decoration: _inputDecoration("Endereço", "Informe seu endereço"),
                  )
                : TextFormField(
                    controller: _controller.enderecoController,
                    decoration: _inputDecoration("Endereço", "Informe o endereço da sua loja"),
                  ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _controller.bairroController,
              decoration: _inputDecoration("Bairro", "Informe seu bairro"),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _controller.complementoController,
              decoration: _inputDecoration("Complemento", "Informe o complemento"),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _controller.cepController,
              decoration: _inputDecoration("CEP", "xxxxx-xxx"),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _controller.cidadeController,
              decoration: _inputDecoration("Cidade", "Informe sua cidade"),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _controller.estadoController,
              decoration: _inputDecoration("Estado", "Informe a sigla do seu estado"),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _controller.latitudeController,
              decoration: _inputDecoration(
                  "Latitude", "Informe a latitude de sua loja"),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _controller.longitudeController,
              decoration: _inputDecoration(
                  "Longitude", "Informe a longitude de sua loja"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pagamentoTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
        child: Column(
          children: [
            Text(
              "Adicionar Cartão de Crédito/Débito",
              style: TextStyle(
                  fontSize: 18, color: const Color.fromARGB(255, 18, 9, 8)),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration:
                  _inputDecoration("Cartão de Crédito", "Número do cartão"),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: _inputDecoration("Validade", "MM/AA"),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: _inputDecoration("CVV", "Código de segurança"),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: _inputDecoration("Senha", "Crie uma senha"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _finalizarCadastro,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Cadastrar"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pixTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
        child: Column(
          children: [
            const Text(
              "Código PIX",
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
            const SizedBox(height: 10),
            Icon(Icons.qr_code, size: 100, color: Colors.red),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Inserir QR Code"),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: _inputDecoration(
                  "Código PIX copia e cola", "Informe o código"),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _finalizarCadastro,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Finalizar Cadastro"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.red),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
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
