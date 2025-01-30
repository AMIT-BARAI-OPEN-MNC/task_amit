import 'package:flutter/material.dart';
import 'package:task_amit/core/services/navigationServices.dart';
import 'package:task_amit/core/uttils/colors.dart';
import 'package:task_amit/router/pageName.dart';

class timeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(title: Text("time")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            NavigationService.push(Pagename.details,
                arguments: {'title': 'Explore World', 'id': 1});
          },
          child: Text("Go to Details"),
        ),
      ),
    );
  }
}
