import 'package:flutter/material.dart';

import 'package:unsplash_gallery_flutter_app/presentation/grid_page.dart';
import 'routes.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Scaffold(
        body: GridPage(),
      ),
      routes: routes,
    );
  }
}