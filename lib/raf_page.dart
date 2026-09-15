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
            Center(child: Text("Column In Center"),)
          ],
        ),
    );
  }
}
