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
  Future<bool> signInWithGoogle() async {
    try {
      setState(() {
        estadoInicioSesion = 'Comprobando datos...';
      });
      var resultado = await Auth().signInWithGoogle();
      if (resultado == null) return false;
      final uid = currentUser?.uid;
      final DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      if (!snapshot.exists) {
        // Crear un nuevo documento para el usuario
        Future.delayed(Duration(seconds: 3), () {
          FirebaseFirestore.instance.collection("users").doc(uid).set({
            "uid": uid,
            "email": currentUser?.email,
            "nombre": currentUser?.displayName,
            "foto": currentUser?.photoURL,
            "fecha": DateTime.now(),
          });
        });
      }

      print('Inicio de sesion con google satisfactorio.');
      return true;
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
  TextEditingController passwordConfirmController = TextEditingController();
  //variables login
  var tryLogin = false;
  var tryLogin2 = false;
  var tryLogin3 = false;
  var isLogin = false;
  var estadoInicioSesion = 'Iniciando sesion...';
  //variables slider
  var sliderLogo_x = 0.0;

  //variables register
  var showRegister = false;
  var showRegister2 = false;
  var correoExisteRegister = false;
  var correoExisteRegister2 = false;
  var checkPassword = false;
  var checkPassword2 = false;
  var sixChars = false;
  var numberUpperCase = false;
  var checkConfirmPassword = false;
  var checkConfirmPassword2 = false;
  var passwordMatch = false;
  var mostrarPassword = false;
  var mostrarConfirmPassword = false;

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
          setState(() {
            tryLogin = !tryLogin;
            sliderLogo_x = _getPosition(sliderKey);
          });
          ;
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
        onPressed: () {
          setState(() {
            showRegister = !showRegister;
          });
          Future.delayed(Duration(milliseconds: 1500), () {
            setState(() {
              showRegister2 = !showRegister2;
            });
          });
        },
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

  Future<bool> isEmailRegistered(String email, String contexto) async {
    final methods =
        await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    return methods.isNotEmpty;
  }

  Widget textFieldCorreo(
      TextEditingController controller, double fontSize, String ventana) {
    return (TextField(
      onTap: () {
        comprobarPassword();
      },
      controller: controller,
      onChanged: (value) {
        if (ventana == 'register') {
          isEmailRegistered(value, ventana).then((value) {
            setState(() {
              correoExisteRegister = value;
            });
            Future.delayed(Duration(milliseconds: 500), () {
              setState(() {
                correoExisteRegister2 = value;
              });
            });
          });
        }
      },
      style: TextStyle(color: colorNaranja, fontSize: fontSize),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email, color: colorNaranja, size: 24),
        suffixIcon: Visibility(
            visible: (ventana == 'login') ? correoExisteRegister : false,
            child: Icon(Icons.check,
                color: Color.fromARGB(255, 84, 14, 148), size: 20)),
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
      onChanged: (value) {
        print(value);
        if (value.length > 0) {
          setState(() {
            checkPassword = true;
          });
          if (value.contains(RegExp(r'[A-Z]')) &&
              value.contains(RegExp(r'[0-9]'))) {
            numberUpperCase = true;
          } else {
            numberUpperCase = false;
          }

          if (value.length > 5) {
            setState(() {
              sixChars = true;
            });
          } else {
            setState(() {
              sixChars = false;
            });
          }

          Future.delayed(Duration(milliseconds: 500), () {
            setState(() {
              checkPassword2 = true;
            });
          });
        } else {
          setState(() {
            checkPassword2 = false;
          });
          Future.delayed(Duration(milliseconds: 500), () {
            setState(() {
              checkPassword = false;
            });
          });
        }

        print(checkPassword);
      },
      controller: controller,
      obscureText: !mostrarPassword ? true : false,
      style: TextStyle(color: colorNaranja, fontSize: fontSize),
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(mostrarPassword
              ? Icons.remove_red_eye
              : Icons.remove_red_eye_outlined),
          color: colorNaranja,
          iconSize: 24,
          onPressed: () {
            setState(() {
              mostrarPassword = !mostrarPassword;
            });
          },
        ),
        prefixIcon: Icon(Icons.lock, color: colorNaranja, size: 24),
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

  void comprobarPassword() {
    if (sixChars && numberUpperCase)
      setState(() {
        checkPassword2 = false;
      });
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        checkPassword = false;
      });
    });
  }

  Widget textFieldConfirmPassword(
      TextEditingController controller, double fontSize) {
    return TextField(
      onTap: () {
        comprobarPassword();
      },
      onChanged: (value) {
        setState(() {
          checkConfirmPassword = true;
          if (value == passwordController.text) {
            passwordMatch = true;
            Future.delayed(Duration(milliseconds: 2000), () {
              setState(() {
                checkConfirmPassword2 = false;
              });
            });
            Future.delayed(Duration(milliseconds: 2500), () {
              setState(() {
                checkConfirmPassword = false;
              });
            });
          } else {
            passwordMatch = false;
          }
          Future.delayed(Duration(milliseconds: 500), () {
            setState(() {
              checkConfirmPassword2 = true;
            });
          });
        });

        print(
            "passwords match $value ${passwordController.text} $passwordMatch");
      },
      style: TextStyle(color: colorNaranja, fontSize: fontSize),
      obscureText: !mostrarConfirmPassword ? true : false,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock_outline, color: colorNaranja, size: 24),
        suffixIcon: IconButton(
          icon: Icon(mostrarConfirmPassword
              ? Icons.remove_red_eye
              : Icons.remove_red_eye_outlined),
          color: colorNaranja,
          iconSize: 24,
          onPressed: () {
            setState(() {
              mostrarConfirmPassword = !mostrarConfirmPassword;
            });
          },
        ),
        hintText: "Confirmar contraseña",
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

  //hacer que sliderLogo se mueva de forma suave a la derecha al
  GlobalKey sliderKey = GlobalKey();

  double _getPosition(GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final posWidget = renderBox.localToGlobal(Offset.zero).dx;
    print("POSITION of Red: $posWidget ");
    return posWidget;
  }

  Widget logo() {
    return (Container(
      width: 400,
      height: 480,
      child: Center(child: Image.asset("assets/logo.png")),
      decoration: BoxDecoration(
          color: colorNaranja,
          borderRadius: BorderRadius.all(Radius.circular(20))),
    ));
  }

  Widget sliderLogo() {
    return (Container(
      width: (tryLogin || showRegister) ? 780 : 400,
      height: 480,
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Stack(
        children: <Widget>[
          AnimatedPositioned(
            left: tryLogin || showRegister ? 380 : 0,
            onEnd: () {
              if (tryLogin) {
                setState(() {
                  tryLogin2 = !tryLogin2;
                  Future.delayed(Duration(milliseconds: 1500), () {
                    signInWithGoogle();
                  });
                });
              }
            }, // here 90 is (200(above container)-110(container which is animating))
            child: InkWell(
                onTap: () {
                  setState(() {
                    tryLogin = !tryLogin;
                  });
                },
                child: logo()),
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
          ),
        ],
      ),
    ));
  }

  Widget vistaLogin(String dispositivo) {
    var fontSize = dispositivo == "web" ? 22.0 : 16.0;
    return (AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: tryLogin ? 0 : 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            //color: Colors.black,
            child: tituloLogin(fontSize),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            width: ancho_login,
            child: textFieldCorreo(correoController, fontSize, 'login'),
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

  Widget vistaCargando(String interfaz) {
    return (Expanded(
        child: Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          child: Text(estadoInicioSesion,
              style: TextStyle(
                  color: colorNaranja,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          margin: EdgeInsets.only(bottom: 20),
        ),
        CircularProgressIndicator(
          color: colorNaranja,
          strokeWidth: 5,
        ),
      ]),
    )));
  }

  Widget tituloRegister(double fontSize) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: (Text(
        "Unete a la comunidad N°1 de cafeterias en linea",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: colorNaranja,
            fontSize: fontSize,
            fontWeight: FontWeight.bold),
      )),
    );
  }

  Widget btnRegister(double fontSize) {
    return (Container(
      height: 50,
      width: ancho_items,
      child: ElevatedButton(
        onPressed: () {},
        child: Text(
          "Crear cuenta",
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

  Widget columnaErrorPassword(String tipo_error) {
    return (Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Debes ingresar 6 caracteres',
              style:
                  TextStyle(color: colorNaranja, fontWeight: FontWeight.bold),
            ),
            Icon(
              sixChars ? Icons.check_circle : Icons.cancel,
              color: colorNaranja,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Se requiere un numero y una mayuscula',
              style:
                  TextStyle(color: colorNaranja, fontWeight: FontWeight.bold),
            ),
            Icon(
              numberUpperCase ? Icons.check_circle : Icons.cancel,
              color: colorNaranja,
            )
          ],
        ),
      ],
    ));
  }

  Widget errorRegister(String tipo_error) {
    return (AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      decoration: BoxDecoration(
          color: colorMorado, borderRadius: BorderRadius.circular(20)),
      width: ancho_items,
      height: (correoExisteRegister && tipo_error == 'email')
          ? 50
          : (checkPassword && tipo_error == 'password')
              ? 100
              : (checkConfirmPassword && tipo_error == 'confirm_password')
                  ? 50
                  : 0,
      margin: EdgeInsets.only(left: 25, right: 25),
      child: Container(
        margin: EdgeInsets.all(10),
        child: tipo_error == 'password'
            ? checkPassword2
                ? columnaErrorPassword(tipo_error)
                : Container()
            : correoExisteRegister2
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'El correo ya existe',
                        style: TextStyle(
                            color: colorNaranja, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.cancel,
                        color: colorNaranja,
                      )
                    ],
                  )
                : (tipo_error == 'confirm_password' && checkConfirmPassword2)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Las contraseñas deben coincidir',
                            style: TextStyle(
                                color: colorNaranja,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            passwordMatch ? Icons.check_circle : Icons.cancel,
                            color: colorNaranja,
                          )
                        ],
                      )
                    : Container(),
      ),
    ));
  }

  Widget vistaRegister(String dispositivo) {
    var fontSize = dispositivo == "web" ? 20.0 : 16.0;
    return (AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: tryLogin ? 0 : 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 50,
            child: tituloRegister(fontSize),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            width: ancho_login,
            child: textFieldCorreo(correoController, fontSize, 'register'),
          ),
          errorRegister('email'),
          SizedBox(
            height: 20,
          ),
          Container(
              height: 50,
              width: ancho_login,
              child: textFieldPassword(passwordController, fontSize)),
          errorRegister('password'),
          SizedBox(
            height: 20,
          ),
          Container(
              height: 50,
              width: ancho_login,
              child: textFieldConfirmPassword(
                  passwordConfirmController, fontSize)),
          errorRegister('confirm_password'),
          SizedBox(
            height: 20,
          ),
          Container(
            child: btnRegister(fontSize),
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
            showRegister2 ? Expanded(child: vistaRegister('web')) : Container(),
            tryLogin2 ? vistaCargando('login') : Container(),
            tryLogin2 || showRegister2 ? logo() : sliderLogo(),
            Container(
              child:
                  (tryLogin || showRegister) ? Container() : vistaLogin('web'),
              width: (tryLogin || showRegister) ? 0 : 370,
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
