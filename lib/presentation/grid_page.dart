import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:unsplash_gallery_flutter_app/models/image.dart';
import 'package:unsplash_gallery_flutter_app/data/network/unsplash_api_client.dart';
import 'package:unsplash_gallery_flutter_app/colors.dart';

class GridPage extends StatefulWidget {
  static final String tag = 'grid_page';
  @override
  createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  List<ImageUnsplash> _images = List();
  Map<String, ImageUnsplash> favorites = Map();
  UnsplashApiClient _apiClient = UnsplashApiClient();
  int _pageNumber = 1;
  bool _isLoading = false;

  Container _buildGridTile(int position, ImageUnsplash img) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      child: Stack(
        children: <Widget>[
          Positioned(
            child: CachedNetworkImage(
              imageUrl: img.thumbImgUrl,
              fit: BoxFit.cover,
            ),
            left: 0.0,
            right: 0.0,
            top: 0.0,
            bottom: 0.0,
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: GestureDetector(
              onTap: () => setState(() {
                print('GestureDetector onTap');
                img.isFavorite = !img.isFavorite;
                if(img.isFavorite)
                  favorites[img.imgId] = img;
                else if(favorites.containsKey(img.imgId))
                  favorites.remove(img.imgId);
              }),
              child: Container(
                height: 35.0,
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                color: colorDarkBlue.withAlpha(50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Container(
                      width: 140.0,
                      child: Text(
                        img.authorName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: colorWhite,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                        maxLines: 1,
                      ),
                    ),
                    Icon(
                      favorites.containsKey(img.imgId)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: favorites.containsKey(img.imgId)
                          ? Colors.red
                          : colorWhite,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _photosGrid() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          automaticallyImplyLeading: true,
          snap: true,
          floating: true,
          elevation: 8.0,
          title: Text('Unsplash Gallery'),
        ),
        new SliverPadding(
          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
          sliver: SliverStaggeredGrid.countBuilder(
            staggeredTileBuilder: (int index) =>
                new StaggeredTile.count(2, index.isEven ? 3 : 2),
            itemBuilder: (BuildContext context, int index) {
              if (index >= (_images.length - 10) && !_isLoading) {
                _isLoading = true;
                _pageNumber += 1;
                _apiClient.getAllImages(_pageNumber).then((imagesList) {
                  setState(() {
                    _images.addAll(imagesList);
                    _isLoading = false;
                  });
                  print(
                      'Page = $_pageNumber. Images List length = ${_images.length}');
                });
              }
              return _buildGridTile(index, _images[index]);
            },
            crossAxisCount: 4,
            itemCount: _images.length,
          ),
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
