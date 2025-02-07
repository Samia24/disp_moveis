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
    _buscarContatos();
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

      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(localizacaoAtual.latitude, localizacaoAtual.longitude),
          ),
        );
      }
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
    );

    setState(() {
      _marcadores.add(marcador);
    });
  }

  void _adicionarMarcadorLoja(String nome, double lat, double lng, String endereco, String telefone, String horario) {
    final marcador = Marker(
      markerId: MarkerId(nome),
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(
        title: nome,
        snippet: 'Clique para mais detalhes',
      ),
      onTap: () {
        _mostrarDetalhesLoja(nome, endereco, telefone, horario);
      },
    );
    setState(() {
      _marcadores.add(marcador);
    });
  }

  void _mostrarDetalhesLoja(String nome, String endereco, String telefone, String horario) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(nome),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Endereço: $endereco'),
              Text('Telefone: $telefone'),
              Text('Horário: $horario'),
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

  Future<void> _buscarContatos() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('contatos').get();
      List<Map<String, dynamic>> contatos = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      setState(() {
        _contatos = contatos;
        for (var contato in contatos) {
          _adicionarMarcadorLoja(
            contato['nome'],
            contato['lat'],
            contato['lng'],
            contato['endereco'] ?? 'Endereço desconhecido',
            contato['telefone'] ?? 'Telefone não informado',
            contato['horario'] ?? 'Horário desconhecido',
          );
        }
      });
    } catch (e) {
      print('Erro ao buscar contatos: $e');
    }
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
        markers: _marcadores,
      ),
    );
  }
}
