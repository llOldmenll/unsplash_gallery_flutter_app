import 'package:flutter/material.dart';

import 'package:unsplash_gallery_flutter_app/presentation/grid_page.dart';
import 'routes.dart';
import 'colors.dart';
import 'package:unsplash_gallery_flutter_app/models/images_provider.dart';
import 'package:unsplash_gallery_flutter_app/models/images_bloc.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ImagesProvider(
      imagesBloc: ImagesBloc(),
      child: new MaterialApp(
        title: 'Flutter Demo',
        home: Scaffold(
          body: GridPage(),
        ),
        routes: routes,
        theme: _buildTheme(),
      ),
    );
  }

  ThemeData _buildTheme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      accentColor: colorLightOrange,
      primaryColor: colorDarkBlue,
//      buttonColor: colorPink100,
      scaffoldBackgroundColor: colorDarkBackground,
//      cardColor: colorWhite,
//      textSelectionColor: colorPink100,
      errorColor: colorErrorRed,
      //TODO: Add the text themes (103)
      //TODO: Add the icon themes (103)
      //TODO: Decorate the inputs (103)
    );
  }
}