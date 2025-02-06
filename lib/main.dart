import 'package:flutter/material.dart';
import 'views/login.dart';
import 'views/cadastro_usuario.dart';
import 'views/mapas.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aller Free',
      theme: ThemeData(       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const Login(), // Adicionado const
      initialRoute: "/login",
      routes: {
        //'/home': (context) => const Home(),
        '/login': (context) => const Login(),
        '/cadastro': (context) => const CadastroUsuario(),
        '/mapas': (context) => const MyHomePage(title: 'Mapas'),
      },
    );
  }
}

