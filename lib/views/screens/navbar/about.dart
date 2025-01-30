import 'package:flutter/material.dart';
import 'package:task_amit/core/uttils/colors.dart';

class aboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(title: Text('about')),
      body: Center(
        child: Text("Details Page - ID: ", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
