import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';

import 'package:prueba/autenticacion.dart';

class VisionUI extends StatefulWidget {
  const VisionUI({super.key});

  @override
  _VisionUIState createState() => _VisionUIState();
}

class _VisionUIState extends State<VisionUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vision UI'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Vision UI'),
          ],
        ),
      ),
    );
  }
}
