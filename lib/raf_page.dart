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
           Text("This is design4"),
           Text("This is desgin5"), 
           Text("This is last design"),
           Text("This is last two desing"), 
           Text("This is last three design"),
           Text("This is last four desing"),
           Text("This is last fifth desing"),
          Text("This is last sixth desing"),
          Text("This is last seventh desing"),
          Text("This is last eighth desing"),
          Text("This is last ninth desing"),
          Text("This is last ten desing"),
            Text("This is last 11th desing"),
            Text("This is  12th desing  "),
          ],
        ),
    );
  }
}