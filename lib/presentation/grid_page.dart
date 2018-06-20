import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:unsplash_gallery_flutter_app/models/image.dart';
import 'package:unsplash_gallery_flutter_app/data/network/unsplash_api_client.dart';

class GridPage extends StatefulWidget {
  static final String tag = 'grid_page';
  @override
  createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  List<ImageUnsplash> _images = List();
  UnsplashApiClient _apiClient = UnsplashApiClient();
  int _pageNumber = 1;
  bool _isLoading = false;

  Container _buildGridTile(ImageUnsplash img) {
    return new Container(
      padding: const EdgeInsets.all(4.0),
      child: CachedNetworkImage(
        imageUrl: img.thumbImgUrl,
        fit: BoxFit.cover,
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
              _apiClient.getAllImages(_pageNumber).then((imagesList) {
                setState(() {
                  _images.addAll(imagesList);
                  _isLoading = false;
                });
                print('Page = $_pageNumber. Images List length = ${_images.length}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new FutureBuilder<List<ImageUnsplash>>(
        future: _apiClient.getAllImages(_pageNumber),
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
}
