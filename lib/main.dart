import 'dart:ui';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prueba/firebase_options.dart';
import 'package:prueba/login/login.dart';
import 'package:prueba/ventanas/eventosUI/allEvents.dart' as allEvents;
import 'package:prueba/ventanas/shoppingUI/shoppingCartUI.dart';
import 'package:webviewx/webviewx.dart';
import 'package:webviewx/webviewx.dart';
import 'dart:html' as html;
import 'package:prueba/ventanas/eventosUI/eventsSavedUI.dart' as eventsSaved;

import 'sliderImagenesHeader/index.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  List<Map<String, dynamic>> listaCompras = [];
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    allEvents.ListaComprasInheritedWidget(
      listaCompras: listaCompras,
      child: eventsSaved.ListaComprasInheritedWidget(
        listaCompras: listaCompras,
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', 'ES'), // Agregar el idioma que deseas utilizar
      ],
      title: 'CoffeeMondo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'CoffeeMondo'),
      routes: {
        '/eventos': (context) => allEvents.EventosUI(tipoUI: ""),
        '/carrito': (context) => ShoppingUI(
              tipoUI: "carrito",
            )
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void initState() {
    super.initState();

    //setup listener ---------------------------------
    // Registra un listener para el evento "message"
  }

  var dispositivo = '';
  int _counter = 0;
  FirebaseAuth auth = FirebaseAuth.instance;
  User? get currentUser => auth.currentUser;
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  var containerWidth = false;
  var containerHeight = 0;
  /*  void setupMessageListener() {} */

  late WebViewXController webviewController;
  @override
  Widget build(BuildContext context) {
    bool usuarioExiste = currentUser != null;
    final ancho_pantalla = MediaQuery.of(context).size.width;
    setState(() {
      if (ancho_pantalla > 1130) {
        dispositivo = 'PC';
      } else {
        dispositivo = 'MOVIL';
      }
    });
    return Scaffold(
        body: PreferredSize(
      preferredSize: Size.fromHeight(MediaQuery.of(context).size.width * 0.75),
      child: Stack(children: [
        index(
          usuario: usuarioExiste,
          imagenes: [
            Image(
              image: AssetImage('assets/MUJER.jpg'),
              fit: BoxFit.cover,
            ),
            Image(
              image: AssetImage('assets/hombre2.png'),
              fit: BoxFit.cover,
            ),
          ],
        ),
      ]),
    ));
  }
}
