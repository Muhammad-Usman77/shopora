import 'package:flutter/material.dart';

class RafPage extends StatefulWidget {
  const RafPage({super.key});

  @override
  State<RafPage> createState() => _RafPageState();
}

class _RafPageState extends State<RafPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Raf Page"),
        ),
        body: Column(
          children: [
           Text("This is Column"),
           Text("This is Row"),
           Text("This is Design"),
           Text("This is Desing"),
           Text("This is Design2"),
           Text("This is design3"),
           Text("This is design4")
          ],
        ),
    );
  }
}