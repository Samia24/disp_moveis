import 'package:flutter/material.dart';

class CadastroUsuario extends StatefulWidget {
  const CadastroUsuario({super.key});

  @override
  State<CadastroUsuario> createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
  bool usuarioAtivado = true; // true para pessoa, false para loja

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
                usuarioAtivado ? Tab(icon: Icon(Icons.payment), text: "Pagamento") : Tab(icon: Icon(Icons.pix), text: "PIX") ,
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
            TextFormField(
              decoration: _inputDecoration("Nome completo", "Informe seu nome completo"),
            ),
            const SizedBox(height: 10),
            usuarioAtivado
                ? TextFormField(
                    decoration: _inputDecoration("CPF", "xxx.xxx.xxx-xx"),
                  )
                : TextFormField(
                    decoration: _inputDecoration("CNPJ", "xx.xxx.xxx/xxxx-xx"),
                  ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: _inputDecoration("Telefone", "(xx) x xxxx-xxxx"),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: _inputDecoration("E-mail", "email@gmail.com"),
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
            if (usuarioAtivado)...[
              TextFormField(
                decoration: _inputDecoration("Endereço", "Informe seu endereço"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: _inputDecoration("Bairro", "Informe seu bairro"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: _inputDecoration("Complemento", "Informe o complemento"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: _inputDecoration("CEP", "xxxxx-xxx"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: _inputDecoration("Cidade", "Informe sua cidade"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: _inputDecoration("Estado", "Informe a sigla do seu estado"),
              ),
            ] else...[              
              TextFormField(
                decoration: _inputDecoration("Endereço", "Informe seu endereço"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: _inputDecoration("Bairro", "Informe seu bairro"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: _inputDecoration("Complemento", "Informe o complemento"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: _inputDecoration("CEP", "xxxxx-xxx"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: _inputDecoration("Cidade", "Informe sua cidade"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: _inputDecoration("Estado", "Informe a sigla do seu estado"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: _inputDecoration("Latitude", "Informe a latitude de sua loja"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: _inputDecoration("Longitude", "Informe a longitude de sua loja"),
              ),
            ],
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
              style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 18, 9, 8)),
            ),
            const SizedBox(height: 20),

            TextFormField(
              decoration: _inputDecoration("Cartão de Crédito", "Número do cartão"),
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
                onPressed: () {},
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
              decoration: _inputDecoration("Código PIX copia e cola", "Informe o código"),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
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
