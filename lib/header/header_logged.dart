//hacer widget header
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:prueba/autenticacion.dart';
import 'package:prueba/login/login.dart';

class HeaderLogged extends StatefulWidget {
  final double ancho_pantalla;
  final bool usuarioLogueado;

  HeaderLogged(this.ancho_pantalla, this.usuarioLogueado);

  @override
  _HeaderLoggedState createState() => _HeaderLoggedState();
}

class _HeaderLoggedState extends State<HeaderLogged> {
  var openLogin = false;
  var openDataVision = false;

  //Colores
  var colorScaffold = Color(0xffffebdcac);
  var colorNaranja = Color.fromARGB(255, 255, 79, 52);
  var colorMorado = Color.fromARGB(0xff, 0x52, 0x01, 0x9b);
  Widget logoMenu() {
    return (Container(
      alignment: Alignment.centerRight,
      child: Image(image: AssetImage('assets/logo.png')),
    ));
  }

  Widget DataVision() {
    return (Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.5,
              color: colorNaranja,
              child: Center(
                child: Text(
                  'DATOS DE VISION',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Impact',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.5,
              color: colorMorado,
              child: Center(
                child: Html(
                    data:
                        '<iframe width="800" height="467" src="https://lookerstudio.google.com/embed/reporting/32e7bee6-09fc-4ebd-a389-52fc9cfcbbfb/page/zf4CD" frameborder="0" style="border:0" allowfullscreen></iframe>'),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget btnIndexMenu() {
    return (GestureDetector(
      onTap: () {
        setState(() {
          openDataVision = !openDataVision;
        });
      },
      child: Container(
          child: Text(
        'COFFEEMONDO',
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'Impact',
            fontSize: 22,
            fontWeight: FontWeight.bold),
      )),
    ));
  }

  Widget btnLoginMenu() {
    print('User logeado ${widget.usuarioLogueado}}');
    return (GestureDetector(
      onTap: () {
        setState(() {
          openLogin = !openLogin;
        });
      },
      child: Container(
          child: Text(
        'VISION AI',
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'Impact',
            fontSize: 22,
            fontWeight: FontWeight.bold),
      )),
    ));
  }

  Future<void> cerrarSesion() async {
    await Auth().signOut();
    print('Usuario ha cerrado sesion');
  }

  Widget btnRegistroMenu() {
    return (GestureDetector(
      onTap: () {
        widget.usuarioLogueado ? cerrarSesion() : print('registrando...');
      },
      child: Container(
          child: Text(
        'CERRAR SESION',
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'Impact',
            fontSize: 22,
            fontWeight: FontWeight.bold),
      )),
    ));
  }

  Widget btnMenuNavegacion() {
    return (Container(
      child: Container(
          child: Text(
        'MENU DE NAVEGACION',
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'Impact',
            fontSize: 12,
            fontWeight: FontWeight.bold),
      )),
    ));
  }

  Widget btnCredenciales() {
    return (GestureDetector(
      onTap: () {
        cerrarSesion();
      },
      child: Container(
          width: MediaQuery.of(context).size.width * 0.25,
          height: MediaQuery.of(context).size.height * 0.03,
          color: colorNaranja,
          child: Center(
            child: Text(
              'CERRAR SESION',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Impact',
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          )),
    ));
  }

  @override
  Widget build(BuildContext context) {
    //print("ancho pantalla ${widget.ancho_pantalla}");
    return Column(
      children: [
        Container(
          height: (widget.ancho_pantalla > 750)
              ? MediaQuery.of(context).size.height * 0.1
              : MediaQuery.of(context).size.width * 0.1,
          margin: EdgeInsets.only(left: 30, right: 30, top: 50),
          child: (ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
                child: Row(children: [
                  logoMenu(),
                  Expanded(
                    //color: Colors.blue,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: (widget.ancho_pantalla > 750)
                            ? [
                                btnIndexMenu(),
                                btnLoginMenu(),
                                btnRegistroMenu()
                              ]
                            : [btnMenuNavegacion(), btnCredenciales()]),
                  )
                ]),
              ),
            ),
          )),
        ),
        AnimatedOpacity(
            opacity: (openLogin) ? 1 : 0,
            duration: Duration(milliseconds: 500),
            child: openLogin ? Login() : Container()),
        AnimatedOpacity(
            opacity: (openDataVision) ? 1 : 0,
            duration: Duration(milliseconds: 500),
            child: openDataVision ? DataVision() : Container())
      ],
    );
  }
}
