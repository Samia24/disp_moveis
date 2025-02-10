import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projeto_final_allerfree/views/store_details_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(widget.title, style: TextStyle(color: const Color.fromARGB(246, 240, 253, 249)),),
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 15.0,
        ),
        markers: _marcadores, // Exibe os marcadores no mapa
      ),
    );
  }

  GoogleMapController? mapController;
  final LatLng _center = const LatLng(-5.066040486433454, -42.72716147593458);
  Set<Marker> _marcadores = {};
  Position? _localizacao;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _contatos = [];

  @override
  void initState() {
    super.initState();
    _obterLocalizacaoAtual();
    _buscarContatos(); // Busca os contatos ao iniciar a tela
  }

  Future<void> _obterLocalizacaoAtual() async {
    try {
      LocationPermission permissao = await Geolocator.checkPermission();
      if (permissao == LocationPermission.denied) {
        permissao = await Geolocator.requestPermission();
        if (permissao == LocationPermission.denied) {
          return;
        }
      }

      if (permissao == LocationPermission.deniedForever) {
        return;
      }

      Position localizacaoAtual = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _localizacao = localizacaoAtual;
        _adicionarMarcador(localizacaoAtual);
      });

      mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(localizacaoAtual.latitude, localizacaoAtual.longitude),
        ),
      );
    } catch (e) {
      print('Erro ao obter localização: $e');
    }
  }

  void _adicionarMarcador(Position localizacao) {
    final marcador = Marker(
      markerId: const MarkerId('localAtual'),
      position: LatLng(localizacao.latitude, localizacao.longitude),
      infoWindow: const InfoWindow(
        title: 'Localização Atual',
        snippet: 'Sua localização atual',
      ),
      onTap: () {
        print('Clicou no marcador da localização atual');
      },
    );

    setState(() {
      _marcadores.add(marcador); // Adiciona o marcador ao conjunto
    });

    _adicionarMarcadoresLojas(); // Adiciona os marcadores das lojas
  }

  void _adicionarMarcadoresLojas() {
    _adicionarMarcadorLoja(
      'Mercado dos Grãos',
      -5.06986,
      -42.78171,
      'Av. Dom Severino - Jockey',
      '(86) 3305-8074',
      'Fecha às 21:00',
    );

    _adicionarMarcadorLoja(
      'Mercado Naturi',
      -5.06863,
      -42.78907,
      'Av. Dom Severino, 1897 - Horto',
      '(86) 99413-4928',
      'Fecha às 20:00',
    );

    _adicionarMarcadorLoja(
      'Mundo Verde',
      -5.07011,
      -42.78342,
      'Av. Dom Severino, 1000 - Jockey Club',
      '(86) 3233-2840',
      'Fecha às 20:30',
    );
  }

  void _adicionarMarcadorLoja(String nome, double lat, double lng,
      String endereco, String telefone, String horario) {
    final marcador = Marker(
      markerId: MarkerId(nome),
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(
        title: nome,
        snippet: 'Clique para ver detalhes',
      ),
      onTap: () {
        _mostrarDetalhesLoja(nome, endereco, telefone, horario);
      },
    );

    setState(() {
      _marcadores.add(marcador); // Adiciona o marcador ao conjunto
    });
  }

  Future<void> _buscarContatos() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('contatos')
          .get(); //retorna todos os documentos da coleção contatos
      List<Map<String, dynamic>> contatos = [];

      for (var doc in querySnapshot.docs) {
        // Percorre todos os documentos armazenados
        contatos.add({
          'nome': doc['nome'],
          'lat': (doc['latitude'] is double)
              ? doc['latitude']
              : double.parse(doc['latitude'].toString()),
          'lng': (doc['longitude'] is double)
              ? doc['longitude']
              : double.parse(doc['longitude'].toString()),
        });
        print(
            'Documento encontrado: ${doc.data()}'); // Verifique se os dados existem
      }
      print(contatos);

      setState(() {
        _contatos = contatos;
      });

      _adicionarMarcadoresLojas();
    } catch (e) {
      print('Erro ao buscar contatos: $e');
    }
  }

  void _navegar_para_tela_produtos_da_loja(BuildContext context2, String nome2,
      String endereco2, String telefone2, String horario2, var produtos2) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context2) => StoreDetailsScreen(
              nome: nome2,
              endereco: endereco2,
              telefone: telefone2,
              horario: horario2,
              produtos: produtos2)),
    );
  }

  void _mostrarDetalhesLoja(
      String nome, String endereco, String telefone, String horario) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(246, 240, 253, 249),
          title: Text(nome, style: TextStyle(color: Colors.red),),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(child: Text('Endereço: $endereco')),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.phone, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(child: Text('Telefone: $telefone')),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(child: Text('Horário: $horario')),
                ],
              ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(200, 40), // Define largura e altura mínimas
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Aumenta o espaçamento interno
                      textStyle: const TextStyle(fontSize: 14), // Ajusta o tamanho do texto
                    ),
                    onPressed: () {
                      _navegar_para_tela_produtos_da_loja(
                          context, nome, endereco, telefone, horario, [
                        {
                          'nome': 'Suco de Laranja Natural',
                          'preco': 8.50,
                          'imagem':
                              'https://i.pinimg.com/originals/b8/82/bf/b882bfe44a972cfbb4006260ccc215c5.jpg'
                        },
                        {
                          'nome': 'Mel Orgânico',
                          'preco': 15.00,
                          'imagem':
                              'https://www.melwenzel.com/wp-content/uploads/2019/09/MEL-ORGANICO-560g.jpg'
                        },
                        {
                          'nome': 'Chá Verde Premium',
                          'preco': 22.90,
                          'imagem':
                              'https://th.bing.com/th?id=OPHS.PkfABtm6kuixHA474C474&w=248&h=248&o=5&pid=21.1'
                        },
                        {
                          'nome': 'Creme de Amendoim',
                          'preco': 18.30,
                          'imagem':
                              'https://estarbem.vtexassets.com/arquivos/ids/155741/597161.png?v=637962539130270000'
                        },
                        {
                          'nome': 'Semente de Chia',
                          'preco': 10.99,
                          'imagem':
                              'https://fthmb.tqn.com/c3DSP60ElP5YcKfx9IaR6jjjjp4=/5175x3450/filters:fill(auto,1)/whole-chia-seeds-98210131-582caae45f9b58d5b1ff4d4b.jpg'
                        },
                        {
                          'nome': 'Leite de Amêndoa',
                          'preco': 12.40,
                          'imagem':
                              'https://th.bing.com/th/id/OIP.quGJkdSBdON69CHktMct1QHaGS?rs=1&pid=ImgDetMain'
                        },
                        {
                          'nome': 'Mix de Frutas Secas',
                          'preco': 20.00,
                          'imagem':
                              'https://http2.mlstatic.com/D_NQ_NP_934782-MLB52482820691_112022-O.webp'
                        },
                        {
                          'nome': 'Café Orgânico',
                          'preco': 25.50,
                          'imagem':
                              'https://th.bing.com/th/id/OIP.qrAX8P8Sh1AvhQ7ryNLrOgHaD3?rs=1&pid=ImgDetMain'
                        },
                        {
                          'nome': 'Pasta de Abacate',
                          'preco': 9.99,
                          'imagem':
                              'https://www.shefa.com.br/wp-content/uploads/2021/10/card2-1-e1635276264386.png'
                        },
                        {
                          'nome': 'Cereal Integral',
                          'preco': 6.99,
                          'imagem':
                              'https://th.bing.com/th/id/OIP.1A2_A0_OZLs5j6zsBv8PEgHaJs?rs=1&pid=ImgDetMain'
                        }
                      ]);
                    },
                    child: Text("Ver produtos", textAlign: TextAlign.center, style: TextStyle(color: const Color.fromARGB(246, 240, 253, 249))),
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(200, 40), // Define largura e altura mínimas
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Aumenta o espaçamento interno
                      textStyle: const TextStyle(fontSize: 14), // Ajusta o tamanho do texto
                    ),
                    // Botão "OK" substituído por ElevatedButton
                    onPressed: () => Navigator.pop(context),
                    child: Text('Fechar', textAlign: TextAlign.center, style: TextStyle(color: const Color.fromARGB(246, 240, 253, 249))),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}
