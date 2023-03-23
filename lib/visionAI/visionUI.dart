import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:video_player/video_player.dart';

class VisionUI extends StatefulWidget {
  const VisionUI({super.key});

  @override
  _VisionUIState createState() => _VisionUIState();
}

class _VisionUIState extends State<VisionUI> {
  //Colores
  var colorScaffold = Color(0xffffebdcac);
  var colorNaranja = Color.fromARGB(255, 255, 79, 52);
  var colorMorado = Color.fromARGB(0xff, 0x52, 0x01, 0x9b);

  //Modulo VisionAI
  var mostrarControl = false;
  var mostrarControl2 = false;
  var mostrarData = false;
  var mostrarData2 = false;
  var mostrarDataStudio = false;
  late VideoPlayerController _controller;
  final videoUrl =
      'https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8';
  void initState() {
    super.initState();

    try {
      _controller = VideoPlayerController.network(videoUrl)
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
      _controller.setVolume(0.0);
    } catch (e) {
      print(e);
    }
  }

  Widget videoPlayer() {
    return (Center(
      child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : Container(),
    ));
  }

  Widget btnsOnOff() {
    return (Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
              color: colorMorado,
              borderRadius: BorderRadius.all(Radius.circular(40))),
          child: IconButton(
              color: colorNaranja,
              iconSize: 30,
              style: ButtonStyle(),
              onPressed: () => print('Prender camara'),
              icon: Icon(Icons.power_settings_new)),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(40))),
          child: IconButton(
              color: colorScaffold,
              iconSize: 30,
              style: ButtonStyle(),
              onPressed: () => print('Apagar camara'),
              icon: Icon(Icons.power_settings_new)),
        ),
      ],
    ));
  }

  Widget consolaMovimiento() {
    return (Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: colorMorado,
              borderRadius: BorderRadius.all(Radius.circular(40))),
          child: IconButton(
              color: colorNaranja,
              iconSize: 30,
              style: ButtonStyle(),
              onPressed: () => print('Mover arriba'),
              icon: Icon(Icons.arrow_upward)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: colorMorado,
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              child: IconButton(
                  color: colorNaranja,
                  iconSize: 30,
                  style: ButtonStyle(),
                  onPressed: () => print('Mover izquierda'),
                  icon: Icon(Icons.arrow_back)),
            ),
            Container(
              decoration: BoxDecoration(
                  color: colorMorado,
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              child: IconButton(
                  color: colorNaranja,
                  iconSize: 30,
                  style: ButtonStyle(),
                  onPressed: () => print('Mover abajo'),
                  icon: Icon(Icons.select_all_outlined)),
            ),
            Container(
              decoration: BoxDecoration(
                  color: colorMorado,
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              child: IconButton(
                  color: colorNaranja,
                  iconSize: 30,
                  style: ButtonStyle(),
                  onPressed: () => print('Mover derecha'),
                  icon: Icon(Icons.arrow_forward)),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
              color: colorMorado,
              borderRadius: BorderRadius.all(Radius.circular(40))),
          child: IconButton(
              color: colorNaranja,
              iconSize: 30,
              style: ButtonStyle(),
              onPressed: () => print('Mover abajo'),
              icon: Icon(Icons.arrow_downward)),
        ),
      ],
    ));
  }

  Widget btnsZoom() {
    return (Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
              color: colorMorado,
              borderRadius: BorderRadius.all(Radius.circular(40))),
          child: IconButton(
              color: colorNaranja,
              iconSize: 30,
              style: ButtonStyle(),
              onPressed: () => print('Zoom in'),
              icon: Icon(Icons.zoom_in_outlined)),
        ),
        Container(
          decoration: BoxDecoration(
              color: colorMorado,
              borderRadius: BorderRadius.all(Radius.circular(40))),
          child: IconButton(
              color: colorNaranja,
              iconSize: 30,
              style: ButtonStyle(),
              onPressed: () => print('Zoom out'),
              icon: Icon(Icons.zoom_out_outlined)),
        ),
      ],
    ));
  }

  Widget vistaVisionAI() {
    return (Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(40),
          ),
          child: videoPlayer(),
        ),
        Container(
          width: 300,
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
              color: colorNaranja,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: Column(children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
              child: btnsOnOff(),
            ),
            Container(
              margin: EdgeInsets.only(top: 50),
              child: consolaMovimiento(),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 60, horizontal: 90),

              //color: Colors.black,
              child: btnsZoom(),
            )
          ]),
        ),
      ],
    ));
  }

  Widget dataStudio() {
    return Html(
      data:
          '<iframe src="https://lookerstudio.google.com/embed/reporting/32e7bee6-09fc-4ebd-a389-52fc9cfcbbfb/page/zf4CD" frameborder="0" style="border:0; width: 100%; height: 100%;" allowfullscreen></iframe>',
    );
  }

  Widget vistaDataStudio() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        mostrarDataStudio = true;
      });
    });
    return Container(
      width: 980,
      height: 540,
      color: Colors.black,
      child: dataStudio(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOutBack,
        height: (mostrarData) ? 700 : 650,
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
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ]),
                    child: Stack(
                      children: [
                        Center(
                            child: Text(
                          'Vision AI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOutBack,
                            width: mostrarData ? 250 : 80,
                            height: 70,
                            decoration: BoxDecoration(
                                color: colorMorado,
                                borderRadius: BorderRadius.circular(40)),
                            child: GestureDetector(
                              onTap: (() {
                                setState(() {
                                  mostrarData = !mostrarData;
                                  mostrarControl2 = false;
                                });
                                Future.delayed(
                                    Duration(
                                        milliseconds: mostrarData2 ? 50 : 550),
                                    () {
                                  setState(() {
                                    mostrarData2 = !mostrarData2;
                                    mostrarControl = false;
                                  });
                                });
                              }),
                              child: mostrarData2
                                  ? Center(
                                      child: Text(
                                        'Estudio de datos',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : Icon(
                                      Icons.dataset_outlined,
                                      color: colorNaranja,
                                      size: 60,
                                    ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOutBack,
                            width: mostrarControl ? 250 : 80,
                            height: 70,
                            decoration: BoxDecoration(
                                color: colorMorado,
                                borderRadius: BorderRadius.circular(40)),
                            child: GestureDetector(
                              onTap: (() {
                                setState(() {
                                  mostrarControl = !mostrarControl;
                                  mostrarData2 = false;
                                });
                                Future.delayed(
                                    Duration(
                                        milliseconds:
                                            mostrarControl2 ? 50 : 550), () {
                                  setState(() {
                                    mostrarControl2 = !mostrarControl2;
                                    mostrarData = false;
                                  });
                                });
                              }),
                              child: mostrarControl2
                                  ? Center(
                                      child: Text(
                                        'Camara remota',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : ImageIcon(
                                      AssetImage('assets/icon.png'),
                                      color: colorNaranja,
                                    ),
                            ),
                          ),
                        )
                      ],
                    )),
                Container(
                    margin: EdgeInsets.only(top: 40),
                    child:
                        (mostrarData2) ? vistaDataStudio() : vistaVisionAI()),
              ],
            )),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
