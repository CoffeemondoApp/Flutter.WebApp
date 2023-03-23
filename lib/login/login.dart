//Crear ventana emergente con el formulario de inicio de sesion, bloquear y obscurecer el fondo
// Path: lib\login\login.dart
// Language: dart
// Framework: flutter

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prueba/autenticacion.dart';
import 'package:prueba/visionAI/visionUI.dart';

import '../../firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_launcher_icons/abs/icon_generator.dart';
import 'package:video_player/video_player.dart';
import 'package:prueba/horizontalDraggable/horizontalDraggable.dart';
import 'package:flutter_launcher_icons/main.dart';

import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? get currentUser => auth.currentUser;

  //funcion para iniciar sesion con google
  Future<void> signInWithGoogle() async {
    try {
      var resultado = await Auth().signInWithGoogle();
      if (resultado == null) return;
      final uid = currentUser?.uid;
      final DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      if (!snapshot.exists) {
        // Crear un nuevo documento para el usuario
        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          'cumpleanos': 'Sin informacion de edad',
          'nickname': "Sin informacion de nombre de usuario",
          'email': resultado!.user!.email,
          'nombre': resultado!.user!.displayName,
          'telefono': 'Sin informacion de telefono',
          'urlImage': resultado!.user!.photoURL,
          'direccion': 'Sin informacion de direccion',
          'nivel': 1,
        });
      }

      print('Inicio de sesion con google satisfactorio.');
    } on FirebaseAuthException catch (e) {
      print(e.message);
      rethrow;
    }
  }

  //comprobar que el usuario esta logead

  var usuarioLogeado = false;

  //Colores
  var colorScaffold = Color(0xffffebdcac);
  var colorNaranja = Color.fromARGB(255, 255, 79, 52);
  var colorMorado = Color.fromARGB(0xff, 0x52, 0x01, 0x9b);
  //Tamaños
  var ancho_items = 350.0;
  var ancho_login = 330.0;
  Offset _containerPosition = Offset.zero;
  //Controladores
  TextEditingController correoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var isLogin = false;

  Widget btnIniciarSesion() {
    return (Container(
      height: 50,
      width: ancho_items,
      child: ElevatedButton(
        onPressed: () {},
        child: Text(
          "Iniciar Sesión",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: colorNaranja,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    ));
  }

  Widget btnIniciarSesionGoogle() {
    return (Container(
      height: 50,
      width: ancho_items,
      child: ElevatedButton(
        onPressed: () {
          signInWithGoogle();
        },
        child: Text(
          "Iniciar Sesión con Google",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: colorMorado,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    ));
  }

  Widget btnRegistro() {
    return (Container(
      height: 50,
      width: ancho_items,
      child: ElevatedButton(
        onPressed: () {},
        child: Text(
          "Soy nuevo",
          style: TextStyle(
            color: colorNaranja,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(0, 0, 0, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: colorNaranja, width: 2),
          ),
        ),
      ),
    ));
  }

  Widget btnsLogin() {
    return (Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [btnIniciarSesion(), btnIniciarSesionGoogle(), btnRegistro()],
    ));
  }

  Widget tituloLogin() {
    return (Center(
      child: Text(
        "Iniciar Sesión",
        style: TextStyle(
          color: colorNaranja,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    ));
  }

  Widget textFieldCorreo(TextEditingController controller) {
    return (TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "Correo",
        hintStyle: TextStyle(
          color: colorNaranja,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: colorNaranja, // Aquí puedes asignar el color que desees
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
              color: colorNaranja,
              width: 2 // Aquí puedes asignar el color que desees
              ),
        ),
      ),
    ));
  }

  Widget textFieldPassword(TextEditingController controller) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Contraseña",
        hintStyle: TextStyle(
          color: colorNaranja,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: colorNaranja, // Aquí puedes asignar el color que desees
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
              color: colorNaranja,
              width: 2 // Aquí puedes asignar el color que desees
              ),
        ),
      ),
    );
  }

  Widget sliderLogo() {
    return (Container(
      width: 390,
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: colorNaranja,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Image(image: AssetImage('/logo.png')),
    ));
  }

  Widget vistaLogin() {
    return (Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            //color: Colors.black,
            height: 50,
            child: tituloLogin(),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            width: ancho_login,
            child: textFieldCorreo(correoController),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              height: 50,
              width: ancho_login,
              child: textFieldPassword(passwordController)),
          SizedBox(
            height: 20,
          ),
          Container(
            child: btnsLogin(),
            //color: Colors.black,
            height: 200,
            width: 330,
          )
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        //print(user.uid);
        setState(() {
          usuarioLogeado = true;
        });
      }
    });
    return (usuarioLogeado)
        ? VisionUI()
        : Dialog(
            backgroundColor: Color.fromARGB(0, 0, 0, 0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: 780,
              decoration: BoxDecoration(
                color: colorScaffold,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: [
                  sliderLogo(),
                  Container(
                    child: vistaLogin(),
                    width: 370,
                    //color: Colors.black,
                  ),
                ],
              ),
            ),
          );
  }
}

class HorizontalDraggableWidget extends StatefulWidget {
  final Widget child;

  HorizontalDraggableWidget({required this.child});

  @override
  _HorizontalDraggableWidgetState createState() =>
      _HorizontalDraggableWidgetState();
}

class _HorizontalDraggableWidgetState extends State<HorizontalDraggableWidget> {
  double _xOffset = 0.0;
  double _startX = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (DragStartDetails details) {
        _startX = details.localPosition.dx;
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        setState(() {
          _xOffset += details.localPosition.dx - _startX;
          _startX = details.localPosition.dx;
        });
      },
      child: Transform.translate(
        offset: Offset(
            (_xOffset > 0)
                ? (_xOffset < 390)
                    ? _xOffset
                    : 390
                : 0,
            0),
        child: widget.child,
      ),
    );
  }
}
