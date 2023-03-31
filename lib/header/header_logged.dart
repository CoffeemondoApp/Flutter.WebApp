//hacer widget header
import 'dart:html';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:prueba/autenticacion.dart';
import 'package:prueba/login/login.dart';
import 'package:prueba/sliderImagenesHeader/dataFrame.dart';
import 'package:prueba/visionAI/asda.dart';

import '../visionAI/visionUIFullScreen.dart';

class HeaderLogged extends StatefulWidget {
  final double ancho_pantalla;
  final bool usuarioLogueado;

  HeaderLogged(this.ancho_pantalla, this.usuarioLogueado);

  @override
  _HeaderLoggedState createState() => _HeaderLoggedState();
}

class _HeaderLoggedState extends State<HeaderLogged> {
  void initState() {
    super.initState();
  }

  var openLogin = false;
  var openLogin2 = false;
  var openDataVision = false;
  var horario = false;

  //Colores
  var colorScaffold = Color(0xffffebdcac);
  var colorNaranja = Color.fromARGB(255, 255, 79, 52);
  var colorMorado = Color.fromARGB(0xff, 0x52, 0x01, 0x9b);

  //BOTONES DE NAVEGACION
  var hoverMenuNavBar = [false, false, false, false, false, false, false];
  var hoverMenuSideBar = false;
  var sideBar = false;
  var sideBar2 = false;
  var sideBar3 = false;
  String dispositivo = '';
  Widget logoMenu() {
    return (Container(
      alignment: Alignment.center,
      child: Image(image: AssetImage('assets/logo.png')),
    ));
  }

  Widget btnIndexMenu() {
    return (GestureDetector(
      onTap: () {
        setState(() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => dataFrame(
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
                        usuario: true,
                      )));
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
    return (GestureDetector(
      onTap: () {
        setState(() {
          openLogin = !openLogin;
        });
      },
      child: Container(
          child: Text(
        'INGRESO',
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
        widget.usuarioLogueado ? 'CERRAR SESION' : 'REGISTRO',
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'Impact',
            fontSize: 22,
            fontWeight: FontWeight.bold),
      )),
    ));
  }

  Widget btnCredenciales() {
    return (GestureDetector(
      onTap: () {},
      child: Container(
          width: MediaQuery.of(context).size.width * 0.25,
          height: MediaQuery.of(context).size.height * 0.03,
          color: colorNaranja,
          child: Center(
            child: Text(
              'INICIAR SESION',
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
                color: colorMorado,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Center(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VisionUIFullScreen()));
                  },
                  child: Container(
                    child: Text(
                      'Abrir Data Studio',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )))
          ],
        ),
      ),
    ));
  }

  Widget btnMenuNavegacion(String btnText, int index, double ancho) {
    var radiusCircularbtn = 10.0;
    return (Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
              onTap: () {
                setState(() {
                  if (btnText == 'INGRESAR AL PORTAL') {
                    openLogin = !openLogin;
                    Future.delayed(Duration(milliseconds: 500), () {
                      openLogin2 = !openLogin2;
                    });
                  }
                });
              },
              splashColor: Color.fromARGB(255, 0, 0, 0),
              onHover: (value) {
                setState(() {
                  hoverMenuNavBar[index] = value;
                });
              },
              child: Row(
                children: [
                  AnimatedContainer(
                    width: (hoverMenuNavBar[index]) ? ancho : 0,
                    duration: Duration(milliseconds: 500),
                    height: (dispositivo == 'PC') ? 50 : 40,
                    decoration: BoxDecoration(
                        color: colorMorado,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(!hoverMenuNavBar[index]
                                ? 0
                                : radiusCircularbtn),
                            bottomRight: Radius.circular(!hoverMenuNavBar[index]
                                ? 0
                                : radiusCircularbtn),
                            topLeft: Radius.circular(radiusCircularbtn),
                            bottomLeft: Radius.circular(radiusCircularbtn))),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width: (!hoverMenuNavBar[index]) ? ancho : 0,
                    height: (dispositivo == 'PC') ? 50 : 40,
                    decoration: BoxDecoration(
                        color: colorNaranja,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(radiusCircularbtn),
                            bottomRight: Radius.circular(radiusCircularbtn),
                            topLeft: Radius.circular(
                                hoverMenuNavBar[index] ? 0 : radiusCircularbtn),
                            bottomLeft: Radius.circular(hoverMenuNavBar[index]
                                ? 0
                                : radiusCircularbtn))),
                  ),
                ],
              )),
          InkWell(
            child: Container(
                child: Text(
              btnText,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Impact',
                  fontSize: (dispositivo == 'PC') ? 18 : 10,
                  fontWeight: FontWeight.bold),
            )),
            onTap: () {
              setState(() {
                openLogin = !openLogin;
              });
            },
            onHover: (value) {
              setState(() {
                hoverMenuNavBar[index] = value;
              });
            },
          )
        ],
      ),
    ));
  }

  void abrirSideBar() {
    setState(() {
      sideBar = !sideBar;
    });
    Future.delayed(Duration(milliseconds: 700), () {
      setState(() {
        sideBar2 = !sideBar2;
      });
    });
    Future.delayed(Duration(milliseconds: 1300), () {
      setState(() {
        sideBar3 = !sideBar3;
      });
    });
  }

  void cerrarSideBar() {
    setState(() {
      sideBar3 = !sideBar3;
    });
    Future.delayed(Duration(milliseconds: 700), () {
      setState(() {
        sideBar2 = !sideBar2;
      });
    });
    Future.delayed(Duration(milliseconds: 1300), () {
      setState(() {
        sideBar = !sideBar;
      });
    });
  }

  Widget btnSideBar(String btnText, IconData icono, int index) {
    return (Container(
        width: 130,
        //color: Colors.white,
        child: InkWell(
          onHover: (value) => print(value),
          onTap: () => print('btn presionado'),
          child: Container(
            decoration: BoxDecoration(
                //color: colorMorado,
                ),
            child: Column(
              children: [
                FilledButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent)),
                  onPressed: () {},
                  child: Icon(icono, color: colorMorado),
                ),
                Text(btnText,
                    style: TextStyle(
                        color: colorMorado,
                        fontFamily: 'Impact',
                        fontSize: dispositivo == 'PC' ? 18 : 10,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        )));
  }

  Widget menuSideBar() {
    return Container(
        //color: Colors.white,
        width: 130,
        margin: EdgeInsets.only(top: 60),
        child: Column(
          children: [
            btnSideBar('Vision AI', Icons.remove_red_eye, 0),
            SizedBox(
              height: 30,
            ),
            btnSideBar('Data Studio', Icons.data_thresholding, 1),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (widget.ancho_pantalla > 1315) {
        dispositivo = 'PC';
      } else {
        dispositivo = 'MOVIL';
      }
    });

    print("Hover Side Bar $hoverMenuSideBar");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: (dispositivo == 'PC') ? 60 : 50,
          child: (ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: colorMorado.withOpacity(0.6),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(colorNaranja),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                          )))),
                      onPressed: () {
                        if (sideBar2) {
                          cerrarSideBar();
                        } else {
                          abrirSideBar();
                        }
                      },
                      child: AnimatedContainer(
                        curve: Curves.easeInOutCubic,
                        duration: Duration(milliseconds: 500),
                        width: (sideBar)
                            ? (dispositivo == 'PC')
                                ? 100
                                : 38
                            : (dispositivo == 'PC')
                                ? sideBar
                                    ? sideBar2
                                        ? 100
                                        : 0
                                    : 30
                                : 30,
                        height: (dispositivo == 'PC') ? 60 : 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight:
                                    Radius.circular(!hoverMenuSideBar ? 0 : 10),
                                bottomRight:
                                    Radius.circular(!hoverMenuSideBar ? 0 : 10),
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10))),
                        child: logoMenu(),
                      )),
                  SizedBox(
                      width: (dispositivo == 'PC')
                          ? MediaQuery.of(context).size.width * 0.2
                          : MediaQuery.of(context).size.width * 0.05),
                  Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: (dispositivo == 'PC')
                            ? [
                                btnMenuNavegacion('COFFEEMONDO', 0, 230),
                                btnMenuNavegacion('INICIAR SESION', 1, 160),
                                btnMenuNavegacion('REGISTRARME', 2, 160),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.0000001),
                              ]
                            : [
                                btnMenuNavegacion('COFFEEMONDO', 0, 140),
                                btnMenuNavegacion('CERRAR SESION', 1, 140),
                                SizedBox(width: 3)
                              ]),
                  )
                ]),
              ),
            ),
          )),
        ),
        (openLogin && !sideBar)
            ? AnimatedOpacity(
                opacity: openLogin2 ? 1 : 0,
                duration: Duration(milliseconds: 500),
                child: Login())
            : Stack(
                children: [
                  openLogin
                      ? AnimatedOpacity(
                          opacity: openLogin2 ? 1 : 0,
                          duration: Duration(milliseconds: 500),
                          child: Login())
                      : Container(),
                  AnimatedContainer(
                      alignment: Alignment.topLeft,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOutCubic,
                      decoration: BoxDecoration(
                        color: colorNaranja,
                        borderRadius: BorderRadius.only(
                            //topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      width: (sideBar2)
                          ? (dispositivo == 'PC')
                              ? 132
                              : 70
                          : 0,
                      height: (dispositivo == 'PC')
                          ? (sideBar)
                              ? MediaQuery.of(context).size.height - 60
                              : 0
                          : (sideBar)
                              ? MediaQuery.of(context).size.height - 50
                              : 0,
                      child: (sideBar3)
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                  menuSideBar(),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          horario = !horario;
                                        });
                                      },
                                      child: Container(
                                        //color: Colors.black,
                                        margin: EdgeInsets.all(10),
                                        child: Icon(
                                            (!horario)
                                                ? Icons.nightlight_outlined
                                                : Icons.wb_sunny_outlined,
                                            color: colorMorado,
                                            size:
                                                dispositivo == 'PC' ? 30 : 20),
                                      ),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.transparent),
                                          shape: MaterialStateProperty.all(
                                              CircleBorder(
                                            side: BorderSide(
                                                color: colorMorado, width: 3),
                                          ))),
                                    ),
                                  ),
                                ])
                          : Container()),
                ],
              ),
        AnimatedOpacity(
            opacity: (openDataVision) ? 1 : 0,
            duration: Duration(milliseconds: 500),
            child: openDataVision ? DataVision() : Container())
      ],
    );
  }
}
