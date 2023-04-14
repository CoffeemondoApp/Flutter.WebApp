//hacer widget header
import 'dart:html';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:prueba/autenticacion.dart';
import 'package:prueba/login/login.dart';
import 'package:prueba/sliderImagenesHeader/dataFrame.dart';
import 'package:prueba/ventanas/dataUI.dart';

import 'package:prueba/ventanas/visionUI.dart';

class Header extends StatefulWidget {
  final double ancho_pantalla;
  final bool usuarioLogueado;

  Header(this.ancho_pantalla, this.usuarioLogueado);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  void initState() {
    super.initState();
  }

  var openLogin = false;
  var openLogin2 = false;
  var openDataVision = false;
  var horario = false;
  var usuarioLogeado = false;

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

  var openVision = false;
  var openVision2 = false;

  var openData = false;
  var openData2 = false;

  var mostrarMenuCafeteria = false;
  var mostrarMenuCafeteria2 = false;
  var mostrarMenuResena = false;
  var mostrarMenuResena2 = false;
  var mostrarMenuServicio = false;
  var mostrarMenuServicio2 = false;

  List<dynamic> activarSubMenuBtnSSB = ['', false, false];

  var hoverSideBar = false;
  var hoverSubSideBar = false;

  String dispositivo = '';
  Widget logoMenu() {
    return (Container(
      alignment: Alignment.center,
      child: Image(
        image: AssetImage('assets/logo.png'),
        fit: BoxFit.fill,
      ),
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
                  onTap: () {},
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

  Future<void> signOut() async {
    await Auth().signOut();
    print('Ha cerrado sesion');
  }

  void abrirLogin() {
    setState(() {
      openLogin = !openLogin;
      Future.delayed(Duration(milliseconds: 500), () {
        openLogin2 = !openLogin2;
      });
    });
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

  void abrirSubMenu(String menu) {
    setState(() {
      if (menu == 'Cafeterias') {
        mostrarMenuCafeteria = true;
        cerrarSubMenu('Reseñas');
        Future.delayed(Duration(milliseconds: 500), () {
          mostrarMenuCafeteria2 = true;
        });
      } else if (menu == 'Reseñas') {
        mostrarMenuResena = true;
        cerrarSubMenu('Cafeterias');
        cerrarSubMenu('Servicios');
        Future.delayed(Duration(milliseconds: 500), () {
          mostrarMenuResena2 = true;
        });
      } else if (menu == 'Servicios') {
        mostrarMenuServicio = true;
        cerrarSubMenu('Cafeterias');
        cerrarSubMenu('Reseñas');
        Future.delayed(Duration(milliseconds: 500), () {
          mostrarMenuServicio2 = true;
        });
      }
    });
  }

  void cerrarSubMenu(String menu) {
    setState(() {
      if (menu == 'Cafeterias') {
        mostrarMenuCafeteria2 = false;
        Future.delayed(Duration(milliseconds: 100), () {
          mostrarMenuCafeteria = false;
        });
      } else if (menu == 'Reseñas') {
        mostrarMenuResena2 = false;
        Future.delayed(Duration(milliseconds: 100), () {
          mostrarMenuResena = false;
        });
      } else if (menu == 'Servicios') {
        mostrarMenuServicio2 = false;
        Future.delayed(Duration(milliseconds: 100), () {
          mostrarMenuServicio = false;
        });
      }
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

  void mostrarVision() {
    setState(() {
      openVision = true;
    });
    Future.delayed(Duration(milliseconds: 500), () {
      openVision2 = true;
    });
  }

  void cerrarVision() {
    setState(() {
      openVision2 = false;
    });
    Future.delayed(Duration(milliseconds: 500), () {
      openVision = false;
    });
  }

  void mostrarData() {
    setState(() {
      openData = true;
    });
    Future.delayed(Duration(milliseconds: 500), () {
      openData2 = true;
    });
  }

  void cerrarData() {
    setState(() {
      openData2 = false;
    });
    Future.delayed(Duration(milliseconds: 500), () {
      openData = false;
    });
  }

  void mostrarLogin() {
    setState(() {
      openLogin = true;
    });
    Future.delayed(Duration(milliseconds: 500), () {
      openLogin2 = true;
    });
  }

  void cerrarLogin() {
    setState(() {
      openLogin2 = false;
    });
    Future.delayed(Duration(milliseconds: 500), () {
      openLogin = false;
    });
  }

  void disparadorBtnSideBar(String menu, bool value) {
    setState(() {
      hoverSideBar = value;
      value
          ? abrirSubMenu(menu)
          : !hoverSubSideBar
              ? Future.delayed(
                  Duration(milliseconds: 200),
                  () {
                    if (!hoverSubSideBar && !hoverSideBar) {
                      cerrarSubMenu(menu);
                    }
                  },
                )
              : null;
    });
  }

  Widget btnSideBar(String menu, IconData icono) {
    return (Container(
        width: 130,
        //color: Colors.white,
        child: InkWell(
          onHover: (value) => {
            print(value),
            setState(() {
              disparadorBtnSideBar(menu, value);
            }),
          },
          onTap: () {
            setState(() {
              if (menu == 'Cafeterias') {
                dispositivo != 'PC' ? abrirSubMenu(menu) : cerrarSubMenu(menu);
              } else if ((menu == 'Cerrar sesion')) {
                cerrarSesion();
              } else if (menu == 'Iniciar sesion') {
                openLogin2 ? cerrarLogin() : abrirLogin();
              }
            });
          },
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
                  onPressed: () {
                    setState(() {
                      if (menu == 'Cafeterias') {
                        dispositivo != 'PC'
                            ? abrirSubMenu(menu)
                            : cerrarSubMenu(menu);
                      }
                    });
                  },
                  child: Icon(icono, color: colorMorado),
                ),
                Text(menu,
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
            btnSideBar('Cafeterias', Icons.coffee_sharp),
            SizedBox(
              height: 30,
            ),
            btnSideBar('Reseñas', Icons.feedback),
            SizedBox(
              height: 30,
            ),
            btnSideBar('Eventos', Icons.event),
            SizedBox(
              height: 30,
            ),
            btnSideBar('Carrito', Icons.shopping_cart),
            usuarioLogeado
                ? SizedBox(
                    height: 30,
                  )
                : Container(),
            usuarioLogeado
                ? btnSideBar('Servicios', Icons.graphic_eq)
                : Container(),
            SizedBox(
              height: 30,
            ),
            usuarioLogeado
                ? btnSideBar('Perfil', Icons.manage_accounts)
                : btnSideBar('Iniciar sesion', Icons.login),
            SizedBox(
              height: 30,
            ),
            usuarioLogeado
                ? btnSideBar('Cerrar sesion', Icons.logout)
                : btnSideBar('Registrarme', Icons.account_circle),
          ],
        ));
  }

  Widget containerSideBar() {
    return (AnimatedContainer(
      curve: Curves.easeInOutCubic,
      duration: Duration(milliseconds: 500),
      width: (sideBar)
          ? (dispositivo == 'PC')
              ? 120
              : 70
          : (dispositivo == 'PC')
              ? sideBar
                  ? sideBar2
                      ? 120
                      : 0
                  : 50
              : 40,
      height: (dispositivo == 'PC')
          ? MediaQuery.of(context).size.height
          : MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          color: colorNaranja,
          border: Border(
            right: mostrarMenuCafeteria
                ? BorderSide(color: colorMorado, width: 1.0)
                : BorderSide.none,
          )),
      child: Column(
        children: [
          GestureDetector(
            child: logoMenu(),
            onTap: () {
              setState(
                () {
                  if (sideBar2) {
                    cerrarSideBar();
                  } else {
                    abrirSideBar();
                  }
                },
              );
            },
          ),
          sideBar2 ? menuSideBar() : Container()
        ],
      ),
    ));
  }

  void disparadorBtnSubSideBar(String menu, bool tieneSubMenu) {
    if (tieneSubMenu) {
      setState(() {
        activarSubMenuBtnSSB[0] = menu;
        activarSubMenuBtnSSB[1] = true;
        Future.delayed(Duration(milliseconds: 350), () {
          activarSubMenuBtnSSB[2] = true;
        });
      });
    }
  }

  Widget btnSubSubSideBar(String menu) {
    return (Container(
      width: (dispositivo == 'PC') ? 190 : 90,
      height: (dispositivo == 'PC') ? 30 : 20,
      child: ElevatedButton(
        onPressed: () {},
        child: Text(menu,
            style: TextStyle(
                color: colorMorado,
                fontFamily: 'Impact',
                fontSize: dispositivo == 'PC' ? 18 : 10,
                fontWeight: FontWeight.bold)),
        style: ButtonStyle(
            shadowColor: MaterialStateProperty.all(colorNaranja),
            backgroundColor: MaterialStateProperty.all(colorNaranja),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)))),
      ),
    ));
  }

  Widget btnSubSideBar(String btnText, int index, bool tieneSubMenu) {
    return AnimatedContainer(
      curve: Curves.easeInOutCubic,
      duration: Duration(milliseconds: 300),
      decoration: activarSubMenuBtnSSB[1] && activarSubMenuBtnSSB[0] == btnText
          ? BoxDecoration(
              color: colorMorado,
              borderRadius: BorderRadius.all(Radius.circular(20)))
          : null,
      width: (dispositivo == 'PC') ? 210 : 100,
      height: (dispositivo == 'PC')
          ? activarSubMenuBtnSSB[1] && activarSubMenuBtnSSB[0] == btnText
              ? 200
              : 56
          : 36,
      child: (activarSubMenuBtnSSB[2] && activarSubMenuBtnSSB[0] == btnText)
          ? Column(
              children: [
                InkWell(
                  onTap: () {
                    activarSubMenuBtnSSB[2] = false;
                    Future.delayed(Duration(milliseconds: 250), () {
                      activarSubMenuBtnSSB[1] = false;
                    });
                  },
                  child: Container(
                    width: (dispositivo == 'PC') ? 190 : 100,
                    height: (dispositivo == 'PC') ? 56 : 36,
                    decoration: BoxDecoration(
                        color: colorMorado,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(btnText,
                              style: TextStyle(
                                  color: colorNaranja,
                                  fontFamily: 'Impact',
                                  fontSize: dispositivo == 'PC' ? 18 : 10,
                                  fontWeight: FontWeight.bold)),
                          Icon(
                            Icons.arrow_drop_up,
                            color: colorNaranja,
                            size: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      btnSubSubSideBar('Mis reseñas'),
                      btnSubSubSideBar('Reseñas guardadas'),
                      btnSubSubSideBar('Todas las reseñas'),
                    ],
                  ),
                )
              ],
            )
          : ElevatedButton(
              onPressed: () {
                disparadorBtnSubSideBar(btnText, tieneSubMenu);
              },
              child: tieneSubMenu
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(btnText,
                            style: TextStyle(
                                color: colorNaranja,
                                fontFamily: 'Impact',
                                fontSize: dispositivo == 'PC' ? 18 : 10,
                                fontWeight: FontWeight.bold)),
                        Icon(
                          Icons.arrow_drop_down,
                          color: colorNaranja,
                          size: 30,
                        )
                      ],
                    )
                  : Text(btnText,
                      style: TextStyle(
                          color: colorNaranja,
                          fontFamily: 'Impact',
                          fontSize: dispositivo == 'PC' ? 18 : 10,
                          fontWeight: FontWeight.bold)),
              style: ButtonStyle(
                  shadowColor: MaterialStateProperty.all(colorMorado),
                  backgroundColor: MaterialStateProperty.all(colorMorado),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)))),
            ),
    );
  }

  Widget menuSubSideBar(String menu) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 50),
        child: menu == 'Cafeterias'
            ? Column(
                children: [
                  btnSubSideBar('Ver cafeterias', 0, false),
                  SizedBox(
                    height: 30,
                  ),
                  btnSubSideBar('Crear cafeteria', 1, false)
                ],
              )
            : menu == 'Reseñas'
                ? Column(
                    children: [
                      btnSubSideBar('Ver reseñas', 0, true),
                      SizedBox(
                        height: 30,
                      ),
                      btnSubSideBar('Crear reseña', 1, false)
                    ],
                  )
                : menu == 'Servicios'
                    ? Column(
                        children: [
                          btnSubSideBar('Vision AI', 0, false),
                          SizedBox(
                            height: 30,
                          ),
                          btnSubSideBar('Data Studio', 1, false)
                        ],
                      )
                    : Container());
  }

  Widget containerSubSideBar() {
    return (AnimatedContainer(
      curve: Curves.decelerate,
      duration: Duration(milliseconds: 300),
      width: (mostrarMenuCafeteria || mostrarMenuResena || mostrarMenuServicio)
          ? (dispositivo == 'PC')
              ? 220
              : 130
          : 0,
      height: (dispositivo == 'PC')
          ? MediaQuery.of(context).size.height
          : MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(3, 3), // changes position of shadow
          ),
        ],
        color: colorNaranja,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: mostrarMenuCafeteria2
          ? menuSubSideBar('Cafeterias')
          : mostrarMenuResena2
              ? menuSubSideBar('Reseñas')
              : mostrarMenuServicio2
                  ? menuSubSideBar('Servicios')
                  : Container(),
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

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          usuarioLogeado = true;
        });
      } else {
        setState(() {
          usuarioLogeado = false;
        });
      }
    });

    return (Stack(
      children: [
        openLogin
            ? AnimatedOpacity(
                opacity: openLogin2 ? 1 : 0,
                duration: Duration(milliseconds: 500),
                child: Login())
            : Container(),
        openVision
            ? AnimatedOpacity(
                opacity: openVision2 ? 1 : 0,
                duration: Duration(milliseconds: 500),
                child: const VisionUI(),
              )
            : Container(),
        openData
            ? AnimatedOpacity(
                opacity: openData2 ? 1 : 0,
                duration: Duration(milliseconds: 500),
                child: DataUI(),
              )
            : Container(),
        Row(
          children: [
            containerSideBar(),
            InkWell(
              mouseCursor: MouseCursor.defer,
              onTap: () {},
              child: containerSubSideBar(),
              onHover: (value) {
                print(value);
                setState(() {
                  hoverSubSideBar = value;
                });
                if (!hoverSubSideBar) {
                  setState(() {
                    mostrarMenuCafeteria2 = false;
                    mostrarMenuResena2 = false;
                    mostrarMenuServicio2 = false;
                  });
                  Future.delayed(Duration(milliseconds: 300), () {
                    setState(() {
                      mostrarMenuCafeteria = false;
                      mostrarMenuResena = false;
                      mostrarMenuServicio = false;
                    });
                  });
                }
              },
            )
          ],
        ),
      ],
    ));
  }
}
