import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    //_buscarContatos(); // Busca os contatos ao iniciar a tela
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
      
      _adicionarMarcadoresContatos(); 
      
    } catch (e) {
      print('Erro ao buscar contatos: $e');
    }
  }

  void _adicionarMarcadoresContatos() {
    for (var contato in _contatos) {
      final marcador = Marker(
        markerId: MarkerId(contato['nome']),
        position: LatLng(contato['lat'], contato['lng']),
        infoWindow: InfoWindow(
          title: contato['nome'],
          snippet: 'Clique para ver detalhes',
        ),
        onTap: () {
          print('Marcador clicado: ${contato['nome']}');
          _mostrarDetalhesContato(contato);
        },
      );

      setState(() {
        _marcadores.add(marcador); // Adiciona o marcador ao conjunto
      });
    }
  }

  void _mostrarDetalhesContato(Map<String, dynamic> contato) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(contato['nome']),
          content: Column(
            mainAxisSize: MainAxisSize.min, //apenas o espaço necessário da tela
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Latitude: ${contato['lat']}'),
              Text('Longitude: ${contato['lng']}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
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
}