import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'image.dart';

class GridPage extends StatefulWidget {
  @override
  createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  List<ImageUnsplash> _images = List();

  int _pageNumber = 1;
  bool _isLoading = false;

  Container _buildGridTile(ImageUnsplash img) {
    return new Container(
      child: CachedNetworkImage(
        imageUrl: img.thumbImgUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new FutureBuilder<List<ImageUnsplash>>(
        future: fetchGet(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData && _pageNumber == 1)
            _images.addAll(snapshot.data);
          return snapshot.hasData
              ? _photosGrid()
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _photosGrid() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          snap: true,
          floating: true,
          elevation: 8.0,
          title: Text('Grid Test'),
        ),
        SliverStaggeredGrid.countBuilder(
          staggeredTileBuilder: (int index) =>
              new StaggeredTile.count(2, index.isEven ? 4 : 3),
          itemBuilder: (BuildContext context, int index) {
            if (index >= (_images.length - 10) && !_isLoading) {
              _isLoading = true;
              _pageNumber += 1;
              fetchGet().then((imagesList) {
                setState(() {
                  _images.addAll(imagesList);
                  _isLoading = false;
                });
                print(
                    'Page = $_pageNumber. Images List length = ${_images.length}');
              });
            }
            return _buildGridTile(_images[index]);
          },
          crossAxisCount: 4,
          itemCount: _images.length,
        ),
      ],
    );
  }

  Future<List<ImageUnsplash>> fetchGet() async {
    print("------ fetchGet() - START LOAD");
    List<ImageUnsplash> images = List();
    Map<String, String> headers = Map();
    headers['Accept-Version'] = 'v1';
    headers['Authorization'] =
        'Client-ID 176a609651fb9ae514b26ceade8b6e2df8f82479213a4fb1332d4d383e9640ff';

    final response = await http.get(
        'https://api.unsplash.com/photos?page=$_pageNumber&per_page=20',
        headers: headers);
    final responseJson = json.decode(response.body);

    for (var obj in responseJson) {
      images.add(ImageUnsplash.fromJson(obj));
    }

    return images;
  }
}
