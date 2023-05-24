import 'dart:convert';
import 'dart:html' as html;
import 'dart:ui';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_network/image_network.dart';
import 'package:mercadopago_sdk/mercadopago_sdk.dart';
import 'package:prueba/sliderImagenesHeader/index.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:webviewx/webviewx.dart';

import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import '../templates/cardTemplate.dart';
import '../shoppingUI/shoppingCartUI.dart';
import 'package:collection/collection.dart';
import "../../header/header.dart";
import 'package:uuid/uuid.dart';

void main() {
  runApp(GetMaterialApp(
    home: misEventosUI(
      tipoUI: null,
    ),
  ));
}

class misEventosUI extends StatefulWidget {
  final tipoUI;

  const misEventosUI({required this.tipoUI});

  @override
  _misEventosUIState createState() => _misEventosUIState();
}

class _misEventosUIState extends State<misEventosUI> {
  //Crear instancia de uuid
  var uuid = Uuid();

  /* final obtenerLista = obtenerListaCompras(); */

  //Colores
  var colorScaffold = Color(0xffffebdcac);
  var colorNaranja = Color.fromARGB(255, 255, 79, 52);
  var colorMorado = Color.fromARGB(0xff, 0x52, 0x01, 0x9b);

  //Modulo VisionAI
  var mp = MP.fromAccessToken(
      "TEST-6395019259410612-042618-e59b68bb43b46338cb4abf5cc3546656-1361503494");
  var activeCamera = false;
  var mostrarControl = false;
  var mostrarControl2 = false;
  var mostrarData = false;
  var mostrarData2 = false;
  var mostrarDataStudio = false;
  var mostrarGridImagenes = true;
  var mostrarGridImagenes2 = false;
  var mostrarFormulario = false;
  var mostrarFormulario2 = false;
  var mostrarDatosUsuario = false;
  var mostrarDatosUsuario2 = false;
  var mostrarCarrito = false;
  var mostrarCarrito2 = false;
  var uidCamara = "";
  var pantalla = 0.0;
  var eventosGuardados = [];
  late VideoPlayerController _controller;
  final videoUrl = 'https://www.visionsinc.xyz/hls/test.m3u8';
  final cartItems = [].obs;
  int cantidadCompras = 0;
  int contadorCompras = 1;
  bool _isLoading =
      false; // Variable para indicar si se están cargando los datos
  bool datosConfirmados = false;
  bool formFilled = false;

  void initState() {
    super.initState();

    obtenerEventosGuardados();
  }

  var dispositivo = '';

  var listaEventos = [];

  var btnEventoHovered = ['', false];

  //------FIREBASE----------//

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //Obtengo toda la informacion de la coleccion eventos
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('eventos');

  Future<List<Map<String, dynamic>>> geteventosData() async {
    QuerySnapshot eventosQuerySnapshot = await _collectionRef.get();
    List<Map<String, dynamic>> eventosDataList = [];
    for (var doc in eventosQuerySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Agrega el ID del documento al mapa de datos
      eventosDataList.add(data);
    }
    setState(() {
      listaEventos = eventosDataList;
    });
    return eventosDataList;
  }

  var nombreEvento = "";

  //-----------FORMULARIO------//

  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _ageHasError = false;
  bool _genderHasError = false;

  var genderOptions = ['Male', 'Female', 'Other'];

  void _onChanged(dynamic val) => debugPrint(val.toString());

//Almacenamos las cantidades seleccionadas

  /* List<int> cantidadesSeleccionadas = []; */
  List<int> cantidadesSeleccionadas = [];

  //Lista donde se almacenarán las fechas seleccionadas
  List<DateTime> fechasSeleccionadas =
      []; // Agrega esta variable para almacenar las fechas seleccionadas

  /* Almacenamos la información del evento seleccionado para utilizarlo en el formualario */
  Map<String, dynamic>? _eventoSeleccionado;

  Map<DateTime, dynamic> cantidadesPorFecha = {};

  bool hoverBtnAddCarrito = false;

  bool _terminosYCondiciones = false;
  bool _politicaDePrivacidad = false;
  bool ingresarInfoManual = false;
  String? _cuponDescuento;

  bool hoverBtnSeguirComprando = false;
  bool hoverBtnConfirmarDatos = false;

  Widget btnSeguirComprando() {
    return (InkWell(
      onTap: () {
        setState(() {
          mostrarDatosUsuario = false;
          mostrarGridImagenes = true;
        });
      },
      onHover: (value) {
        setState(() {
          hoverBtnSeguirComprando = value;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInCubic,
        width: 260,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: hoverBtnSeguirComprando ? colorMorado : colorNaranja,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.arrow_back,
                color: hoverBtnSeguirComprando ? colorNaranja : colorMorado,
              ),
              Text(
                'Seguir comprando',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        hoverBtnSeguirComprando ? colorNaranja : colorMorado),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget btnMercadoPago() {
    return (Container(
      width: 900,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(2)),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            margin: EdgeInsets.only(right: 25),
            child: Text(
              'Comprar con ',
              style: TextStyle(
                  color: Color.fromARGB(255, 0, 191, 255),
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Tahoma Normal'),
            ),
          ),
          Image.asset(
            'assets/mercadopago.png',
            width: 35,
          ),
        ]),
      ),
    ));
  }

  Widget moduloInformacion(String descripcion) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: colorMorado,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(descripcion,
                        style: TextStyle(
                            color: colorNaranja,
                            fontSize: dispositivo == 'PC' ? 16 : 14,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget moduloFecha(String fecha) {
    List<String> separarFecha = fecha.split(' - ');
    if (separarFecha[0] == separarFecha[1]) {
      fecha = separarFecha[0];
    } else {
      fecha = fecha;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: colorMorado,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Icon(Icons.date_range_outlined,
                      color: colorNaranja, size: dispositivo == 'PC' ? 24 : 20),
                ),
                Text(
                  fecha,
                  style: TextStyle(
                      color: colorNaranja,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String nombreEventoActual = "";

  //Obtengo toda la informacion de la coleccion eventos
  CollectionReference _collectionRefOrden =
      FirebaseFirestore.instance.collection('ordenesDeCompra');

  Widget btnEvento(
      IconData icono, String tipo, String nombre, String UidEvento) {
    return InkWell(
      onHover: (value) {
        if (value) {
          setState(() {
            btnEventoHovered = [tipo, true];
          });
        } else {
          setState(() {
            btnEventoHovered = [tipo, false];
          });
        }
      },
      onTap: () {
        print('Guardar evento');
        print('$tipo');
        print(eventosGuardados);
        if (tipo == 'Guardar evento') {
          eventosGuardados.contains(UidEvento)
              ? borrarFavoritos(UidEvento)
              : subirFavoritos(UidEvento);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: (btnEventoHovered[0] == tipo &&
                  btnEventoHovered[1] == true &&
                  nombreEventoActual == nombre)
              ? Color.fromARGB(255, 107, 0, 200)
              : colorMorado,
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: Container(
          margin: EdgeInsets.all(10),
          child: Icon(icono, color: colorNaranja, size: 26),
        ),
      ),
    );
  }

  Widget btnsEvento(String nombre, String uid, String? userUid,
      eventoSeleccionado, entryValue) {
    return Container(
      margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.1, bottom: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          btnEvento(Icons.info_outline, 'Información', nombre, uid),
          InkWell(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: colorMorado, // Color de fondo morado
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              padding: EdgeInsets.all(12),
              child: Icon(Icons.attach_money_rounded,
                  color: colorNaranja), // Icono naranja
            ),
          ),
          btnEvento(Icons.map_outlined, 'Mapa', nombre, uid),
          btnEvento(
              eventosGuardados.contains(uid)
                  ? Icons.favorite
                  : Icons.favorite_border_outlined,
              "Guardar evento",
              nombre,
              uid)
        ],
      ),
    );
  }

  Future<void> subirFavoritos(String UidEvento) async {
    try {
      // Importante: Este tipo de declaracion se utiliza para solamente actualizar la informacion solicitada y no manipular informacion adicional, como lo es la imagen y esto permite no borrar otros datos importantes
      User? user = FirebaseAuth.instance.currentUser;
      print(UidEvento);
      print(eventosGuardados);
      // Se busca la coleccion 'users' de la BD de Firestore en donde el uid sea igual al del usuario actual
      final DocumentReference docRef =
          FirebaseFirestore.instance.collection("users").doc(user?.uid);

      docRef.update({
        'eventosGuardados': FieldValue.arrayUnion([UidEvento])
      });
      print('Evento $UidEvento agregado con exito a favoritos');
      obtenerEventosGuardados();
      // Una vez actualizada la informacion, se devuelve a InfoUser para mostrar su nueva informacion
    } catch (e) {
      print("Error al intentar ingresar informacion");
    }
  }

  Future<void> borrarFavoritos(String uidEvento) async {
    try {
      // Importante: Este tipo de declaracion se utiliza para solamente actualizar la informacion solicitada y no manipular informacion adicional, como lo es la imagen y esto permite no borrar otros datos importantes
      User? user = FirebaseAuth.instance.currentUser;
      print(uidEvento);
      print(eventosGuardados);
      // Se busca la coleccion 'users' de la BD de Firestore en donde el uid sea igual al del usuario actual
      final DocumentReference docRef =
          FirebaseFirestore.instance.collection("users").doc(user?.uid);
      // Se actualiza la informacion del usuario actual mediante los controladores, que son los campos de informacion que el usuario debe rellenar

      docRef.update({
        'eventosGuardados': FieldValue.arrayRemove([uidEvento])
      });
      print('Evento $uidEvento borrado de favoritos.');
      obtenerEventosGuardados();
      // Una vez actualizada la informacion, se devuelve a InfoUser para mostrar su nueva informacion
    } catch (e) {
      print("Error al intentar ingresar informacion");
    }
  }

  Future<String> obtenerUidEvento(String nombre) {
    var firestore = FirebaseFirestore.instance;
    return firestore
        .collection('eventos')
        .where('nombre', isEqualTo: nombre)
        .get()
        .then((value) => value.docs.first.id);
  }

  Future<List<dynamic>?> obtenerEventosGuardados() async {
    User? user = FirebaseAuth.instance.currentUser;
    firestore.collection('users').doc(user?.uid).get().then((value) {
      setState(() {
        eventosGuardados = value.data()!['eventosGuardados'];
      });
    });
  }

  Widget gridImagenes() {
    int contador = 0;
    int contadorCompras = 1;
    var listaElementos = [];

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: geteventosData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox();
        }

        List<Map<String, dynamic>> cafeteriasDataList = snapshot.data!;

        return Align(
          child: CarouselSlider(
            options: CarouselOptions(
              enlargeCenterPage: true,
              viewportFraction: dispositivo == 'PC' ? 0.4 : 0.9,
              aspectRatio: 16 / 9,
              disableCenter: true,
              enableInfiniteScroll: false,
              autoPlayCurve: Curves.fastOutSlowIn,
              autoPlay: false,
              height: dispositivo == 'PC'
                  ? MediaQuery.of(context).size.height * 0.72
                  : MediaQuery.of(context).size.height * 0.85,
            ),
            items: cafeteriasDataList.asMap().entries.map((entry) {
              int index = entry.key;
              String uidEvento = entry.value["id"] ?? "";
              String nombre = entry.value["nombre"] ?? "";
              String urlImagen = entry.value["imagen"] ?? "";
              String cafeteria = entry.value["cafeteria"] ?? "";
              String lugar = entry.value["lugar"] ?? "";
              String descripcion = entry.value["descripcion"] ?? "";
              String fecha = entry.value["fecha"] ?? "";
              String ubicacion = entry.value["ubicacion"] ?? "";
              String precio = entry.value["precio"].toString();

              return Container(
                  width: dispositivo == "PC"
                      ? MediaQuery.of(context).size.width - 600
                      : MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 0, top: 0),
                  child: cardTemplate(
                      template: "Eventos",
                      title: ubicacion,
                      building: cafeteria,
                      title2: nombre,
                      title3: precio,
                      image: urlImagen,
                      dispositivo: dispositivo,
                      body: Container(
                        width: 500,
                        height: 236,
                        child: Column(
                          children: [
                            Expanded(
                                child: Column(children: [
                              moduloInformacion(descripcion),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.event_outlined,
                                          color: colorMorado, size: 20),
                                      Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: Text(nombre,
                                            style: TextStyle(
                                                color: colorMorado,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ]),
                              ),
                            ])),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  moduloFecha(fecha),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  btnsEvento(
                                      'Nombre del evento',
                                      uidEvento,
                                      'ID del evento',
                                      _eventoSeleccionado,
                                      entry.value)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      icon: Icons.location_on));
            }).toList(),
          ),
        );
      },
    );
  }

/*   Widget formularioEventos(){
    return 
  }; */

/* ----------------------Info GPAY--------------------------------------- */
  /* -------------------CANAL ENTRE JS Y FLUTTER------------- */
  final webViewChannel = EventChannel('webViewChannel');
  late WebViewXController webviewController;
  int total = 0;
  int precioUnitario = 0;

/* ---------------------VISTA CARRITO--------------------------------- */
  int _total = 0;

  Widget vistaCarrito(List<Map<String, dynamic>> listaCompras) {
    bool existeCompraUsuario = false;
    for (var compra in listaCompras) {
      if (compra.values.first['nombre'] == compra["nombre"]) {
        existeCompraUsuario = true;
        break;
      }
    }

    int precioUnitario = 100;
    _total = 0; // reiniciar la variable _total

    listaCompras.forEachIndexed((index, compra) {
      // utilizar forEachIndexed en lugar de forEach
      if (compra == null || compra.isEmpty) {
        return;
      }
      compra = listaCompras[index]['compra${index + 1}'];
      var cantidad = int.parse(compra['cantidad'] ?? '1');
      var precioTotal = cantidad * int.parse(compra["precio"]);
      _total += precioTotal; // agregar el precio total al total
    });
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorScaffold,
      ),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                width: MediaQuery.of(context).size.width / 3.3,
                height: 165,
                margin: EdgeInsets.only(bottom: 10),
                child: Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: listaCompras.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: listaCompras.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final compra =
                                      listaCompras[index]['compra${index + 1}'];
                                  if (compra == null || compra.isEmpty) {
                                    return SizedBox();
                                  }

                                  // Obtener la cantidad actual del artículo
                                  final cantidad =
                                      int.parse(compra['cantidad'] ?? '1');

                                  var precioTotal =
                                      cantidad * int.parse(compra['precio']);
                                  /* 1 *100 = 100
                                    2* 100 = 200
                                    total = total + precio total
                                      100      0      100
                                      300         100   + 200
                                                300        300
                                      
                                   */

                                  return Expanded(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                compra!['eventoNombre'] ?? '',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 120,
                                              child: Text(
                                                  DateFormat('dd/MM/yyyy')
                                                      .format(
                                                    compra['fecha']
                                                            ?.toLocal() ??
                                                        DateTime.now(),
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                width: 100,
                                                child: Wrap(
                                                  spacing: 10,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                          icon: Icon(
                                                              Icons.remove),
                                                          onPressed: () {
                                                            setState(() {
                                                              if (cantidad >
                                                                  1) {
                                                                listaCompras[
                                                                            index]
                                                                        [
                                                                        'compra${index + 1}']![
                                                                    'cantidad'] = (cantidad -
                                                                        1)
                                                                    .toString();
                                                                _total -= int
                                                                    .parse(compra[
                                                                        'precio']);
                                                                print(
                                                                    listaCompras);
                                                              } else {
                                                                listaCompras[
                                                                            index]
                                                                        [
                                                                        'compra${index + 1}']![
                                                                    'cantidad'] = '1';
                                                              }
                                                            });
                                                          },
                                                        ),
                                                        Text(
                                                          '$cantidad',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        IconButton(
                                                          icon: Icon(Icons.add),
                                                          onPressed: () {
                                                            setState(() {
                                                              listaCompras[index]
                                                                          [
                                                                          'compra${index + 1}']![
                                                                      'cantidad'] =
                                                                  (cantidad + 1)
                                                                      .toString();
                                                              _total += int
                                                                  .parse(compra[
                                                                      'precio']);
                                                              print(
                                                                  listaCompras);

                                                              print(_total);
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                  '\$${precioTotal.toString()}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                setState(() {
                                                  if (index ==
                                                      listaCompras.length - 1) {
                                                    listaCompras
                                                        .removeAt(index);
                                                  } else {
                                                    // Actualiza los nombres de las compras
                                                    for (int i = index + 1;
                                                        i < listaCompras.length;
                                                        i++) {
                                                      listaCompras[i]
                                                              ['compra${i}'] =
                                                          listaCompras[i].remove(
                                                              'compra${i + 1}');
                                                    }
                                                    listaCompras
                                                        .removeAt(index);
                                                  }
                                                  print(listaCompras);
                                                  contadorCompras--;
                                                  cantidadCompras--;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        Divider(),
                                      ],
                                    ),
                                  );
                                })
                            : Center(
                                child: Text(
                                  'No hay compras en tu carrito',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }

  /* ----------------RESUMEN CARRITO--------------------------- */

  Widget resumenCarrito(
      List<Map<String, dynamic>> listaCompras, Function setState) {
    bool existeCompraUsuario = false;
    for (var compra in listaCompras) {
      if (compra.values.first['nombre'] == compra["nombre"]) {
        existeCompraUsuario = true;
        break;
      }
    }

    int precioUnitario = 100;
    _total = 0; // reiniciar la variable _total

    listaCompras.asMap().forEach((index, compra) {
      if (compra == null || compra.isEmpty) {
        return;
      }
      var cantidad = int.parse(compra['compra${index + 1}']['cantidad'] ?? '1');
      var precioTotal =
          cantidad * int.parse(compra['compra${index + 1}']['precio']);
      _total += precioTotal; // agregar el precio total al total
    });

    return Dialog(
      child: Container(
        color: colorScaffold,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 3.5,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
                color: colorMorado,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Resumen de tu compra',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width / 3.5,
                height: MediaQuery.of(context).size.height / 8,
                child: SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: listaCompras.length,
                    itemBuilder: (BuildContext context, int index) {
                      final compra = listaCompras[index]['compra${index + 1}'];

                      int cantidad = int.parse(compra['cantidad'] ?? '1');
                      int precio = int.parse(compra['precio']);

                      void incrementarCantidad() {
                        setState(() {
                          cantidad++;
                          listaCompras[index]['compra${index + 1}']
                              ['cantidad'] = cantidad.toString();
                        });
                      }

                      void decrementarCantidad() {
                        setState(() {
                          if (cantidad > 1) {
                            cantidad--;
                            listaCompras[index]['compra${index + 1}']
                                ['cantidad'] = cantidad.toString();
                          }
                        });
                      }

                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(compra['eventoNombre']),
                              Text(DateFormat('dd/MM/yyyy')
                                  .format(compra['fecha'].toLocal())),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: decrementarCantidad,
                                  ),
                                  Text(cantidad.toString()),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: incrementarCantidad,
                                  ),
                                ],
                              ),
                              Text('\$${cantidad * precio}'),
                            ],
                          ),
                          Divider(),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text('Total: \$$_total'),
            SizedBox(height: 10),
            SizedBox(
                width: MediaQuery.of(context).size.width / 3.5,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      mostrarGridImagenes = false;
                      mostrarDatosUsuario = true;
                      Navigator.pop(context);
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(colorMorado),
                  ),
                  child: Text('Continuar con mi pedido'),
                ))
          ],
        ),
      ),
    );
  }

  Widget textoFecha(String dia) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        dia,
        style: TextStyle(
          color: colorNaranja,
          fontSize: dispositivo == 'PC' ? 14 : 12,
        ),
      ),
    );
  }

  Widget barrasVentas(String dia) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3),
      child: Container(
        height: 200,
        width: 25,
        decoration: BoxDecoration(
            color: colorNaranja,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5))),
      ),
    );
  }

  String obtenerMes() {
    String mes = "";
    DateTime fecha = DateTime.now();
    switch (fecha.month) {
      case 1:
        mes = "Enero";
        break;
      case 2:
        mes = "Febrero";
        break;
      case 3:
        mes = "Marzo";
        break;
      case 4:
        mes = "Abril";
        break;
      case 5:
        mes = "Mayo";
        break;
      case 6:
        mes = "Junio";
        break;
      case 7:
        mes = "Julio";
        break;
      case 8:
        mes = "Agosto";
        break;
      case 9:
        mes = "Septiembre";
        break;
      case 10:
        mes = "Octubre";
        break;
      case 11:
        mes = "Noviembre";
        break;
      case 12:
        mes = "Diciembre";
        break;
      default:
    }
    return mes;
  }

  Widget indiceValor(int valor) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Text(
        valor.toString(),
        style: TextStyle(
            color: colorNaranja,
            fontSize: dispositivo == 'PC' ? 14 : 12,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget vistaWeb() {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      if (listaEventos.isNotEmpty && nombreEventoActual == "") {
        nombreEventoActual = listaEventos[0]["nombre"];
      }
    });
    return (Dialog(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOutBack,
            height: MediaQuery.of(context).size.height - 50,
            width: 1280,
            decoration: BoxDecoration(
                color: colorScaffold,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ]),
            child: Container(
                margin: EdgeInsets.only(top: 50, left: 50, right: 50),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: colorNaranja,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ]),
                        child: Stack(
                          children: [
                            Center(
                                child: Text(
                              'Mis eventos',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: colorMorado,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 25, horizontal: 35),
                                    child: Icon(
                                      Icons.graphic_eq_outlined,
                                      color: Colors.white,
                                      size: 36,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          children: [
                            Container(
                              width: 650,
                              height: 300,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: colorMorado,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ]),
                              child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 10),
                                  child: Column(
                                    children: [
                                      Center(
                                        child: Text(
                                          obtenerMes(),
                                          style: TextStyle(
                                              color: colorNaranja,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                          child: Container(
                                        decoration: BoxDecoration(),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                indiceValor(1000),
                                                indiceValor(500),
                                                indiceValor(0),
                                              ],
                                            ),
                                            barrasVentas('15'),
                                            barrasVentas('16'),
                                            barrasVentas('17'),
                                            barrasVentas('18'),
                                            barrasVentas('19'),
                                            barrasVentas('20'),
                                            barrasVentas('21'),
                                            barrasVentas('22'),
                                            barrasVentas('23'),
                                            barrasVentas('24'),
                                            barrasVentas('25'),
                                            barrasVentas('26'),
                                            barrasVentas('27'),
                                            barrasVentas('28'),
                                            barrasVentas('29'),
                                          ],
                                        ),
                                      )),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text(
                                              '1000',
                                              style: TextStyle(
                                                  color: Colors.transparent,
                                                  fontSize: dispositivo == 'PC'
                                                      ? 14
                                                      : 12,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                          textoFecha('15'),
                                          textoFecha('16'),
                                          textoFecha('17'),
                                          textoFecha('18'),
                                          textoFecha('19'),
                                          textoFecha('20'),
                                          textoFecha('21'),
                                          textoFecha('22'),
                                          textoFecha('23'),
                                          textoFecha('24'),
                                          textoFecha('25'),
                                          textoFecha('26'),
                                          textoFecha('27'),
                                          textoFecha('28'),
                                          textoFecha('29'),
                                        ],
                                      )
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      )
                    ])))));
  }

  Widget vistaMobile() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 50,
      decoration: BoxDecoration(color: colorScaffold),
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: colorMorado,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            'Entradas',
                            style: TextStyle(
                                color: colorNaranja,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          Icon(
                            Icons.shopping_cart_sharp,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          if (cantidadCompras > 0)
                            Container(
                              padding: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                cantidadCompras.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              margin: EdgeInsets.only(left: 5),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height - 150,
              decoration: BoxDecoration(
                color: colorScaffold,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            /* if (pantalla < 882)
            Container(
              height: MediaQuery.of(context).size.height - 600,
              child: columnaControlCamara(),
            )
          else
            filaControlCamara(), */
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ancho_pantalla = MediaQuery.of(context).size.width;
    setState(() {
      pantalla = ancho_pantalla;
    });
    print(pantalla);
    setState(() {
      if (ancho_pantalla > 1130) {
        dispositivo = 'PC';
      } else {
        dispositivo = 'MOVIL';
      }
    });
    return (dispositivo == 'PC') ? vistaWeb() : vistaMobile();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
