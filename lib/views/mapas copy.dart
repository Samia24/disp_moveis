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
        title: Text(widget.title),
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
      'Mercado do Grão',
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

  void _adicionarMarcadorLoja(String nome, double lat, double lng, String endereco, String telefone, String horario) {
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
      QuerySnapshot querySnapshot = await _firestore.collection('contatos').get(); //retorna todos os documentos da coleção contatos
      List<Map<String, dynamic>> contatos = [];

      for (var doc in querySnapshot.docs) { // Percorre todos os documentos armazenados
        contatos.add({
         'nome': doc['nome'],
        'lat': (doc['latitude'] is double) ? doc['latitude'] : double.parse(doc['latitude'].toString()),
        'lng': (doc['longitude'] is double) ? doc['longitude'] : double.parse(doc['longitude'].toString()),
        });
        print('Documento encontrado: ${doc.data()}'); // Verifique se os dados existem
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


  void _navegar_para_tela_produtos_da_loja(BuildContext context2,String nome2, String endereco2, String telefone2, String horario2, var produtos2){
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context2) => StoreDetailsScreen(nome: nome2, endereco:endereco2, telefone:telefone2, horario:horario2, produtos:produtos2)
        ),
      );
  }
  void _mostrarDetalhesLoja(String nome, String endereco, String telefone, String horario) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(nome),
          content: Column(
            mainAxisSize: MainAxisSize.min, //apenas o espaço necessário da tela
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Endereço: $endereco'),
              Text('Telefone: $telefone'),
              Text('Horário: $horario'),
              ElevatedButton(onPressed:()=>{
                  _navegar_para_tela_produtos_da_loja(context, nome, endereco, telefone, horario, 
                  
                   [
        {
          'nome': 'Farinha de Amêndoa',
          'preco': 25.99,
          'imagem': 'https://via.placeholder.com/150'
        },
        {
          'nome': 'Óleo de Coco',
          'preco': 18.50,
          'imagem': 'https://via.placeholder.com/150'
        },
        {
          'nome': 'Granola Natural',
          'preco': 12.75,
          'imagem': 'https://via.placeholder.com/150'
        },
      ],
                  
                  
                  )
              } , child: Text("ver produtos"   ))
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Fechar'),
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