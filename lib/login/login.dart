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

  Widget btnIniciarSesion(double fontSize) {
    return (Container(
      height: 50,
      width: ancho_items,
      child: ElevatedButton(
        onPressed: () {},
        child: Text(
          "Iniciar Sesión",
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
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

  Widget btnIniciarSesionGoogle(double fontSize) {
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
            fontSize: fontSize,
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

  Widget btnRegistro(double fontSize) {
    return (Container(
      height: 50,
      width: ancho_items,
      child: ElevatedButton(
        onPressed: () {},
        child: Text(
          "Soy nuevo",
          style: TextStyle(
            color: colorNaranja,
            fontSize: fontSize,
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

  Widget btnsLogin(double fontSize) {
    return (Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        btnIniciarSesion(fontSize),
        btnIniciarSesionGoogle(fontSize),
        btnRegistro(fontSize)
      ],
    ));
  }

  Widget tituloLogin(double fontSize) {
    return (Center(
      child: Text(
        "Iniciar Sesión",
        style: TextStyle(
          color: colorNaranja,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    ));
  }

  Widget textFieldCorreo(TextEditingController controller, double fontSize) {
    return (TextField(
      controller: controller,
      style: TextStyle(color: colorNaranja, fontSize: fontSize),
      decoration: InputDecoration(
        hintText: "Correo",
        hintStyle: TextStyle(
          fontSize: fontSize,
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

  Widget textFieldPassword(TextEditingController controller, double fontSize) {
    return TextField(
      style: TextStyle(color: colorNaranja, fontSize: fontSize),
      decoration: InputDecoration(
        hintText: "Contraseña",
        hintStyle: TextStyle(color: colorNaranja, fontSize: fontSize),
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
      child: Image(image: AssetImage('assets/logo.png')),
    ));
  }

  Widget vistaLogin(String dispositivo) {
    var fontSize = dispositivo == "web" ? 24.0 : 16.0;
    return (Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            //color: Colors.black,
            height: 50,
            child: tituloLogin(fontSize),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            width: ancho_login,
            child: textFieldCorreo(correoController, fontSize),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              height: 50,
              width: ancho_login,
              child: textFieldPassword(passwordController, fontSize)),
          SizedBox(
            height: 20,
          ),
          Container(
            child: btnsLogin(fontSize),
            //color: Colors.black,
            height: 200,
            width: 330,
          )
        ],
      ),
    ));
  }

  Widget loginWeb() {
    return (Dialog(
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
              child: vistaLogin('web'),
              width: 370,
              //color: Colors.black,
            ),
          ],
        ),
      ),
    ));
  }

  Widget loginMobile() {
    return (Dialog(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              color: colorScaffold, borderRadius: BorderRadius.circular(40)),
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          child: vistaLogin('mobile'),
        )));
  }

  @override
  Widget build(BuildContext context) {
    final ancho_pantalla = MediaQuery.of(context).size.width;
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
        : (ancho_pantalla > 842)
            ? loginWeb()
            : loginMobile();
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
