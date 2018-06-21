import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:unsplash_gallery_flutter_app/models/image.dart';
import 'package:unsplash_gallery_flutter_app/data/network/unsplash_api_client.dart';
import 'package:unsplash_gallery_flutter_app/models/images_provider.dart';
import 'package:unsplash_gallery_flutter_app/models/images_bloc.dart';
import 'package:unsplash_gallery_flutter_app/colors.dart';
import 'pager_page.dart';

class GridPage extends StatefulWidget {
  static final String tag = 'grid_page';
  @override
  createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
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
            child: GestureDetector(
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            PagerPage(favorites, position)),
                  ),
              child: Hero(
                tag: img.imgId,
                child: CachedNetworkImage(
                  imageUrl: img.thumbImgUrl,
                  fit: BoxFit.cover,
                ),
              ),
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
                    if (img.isFavorite)
                      favorites[img.imgId] = img;
                    else if (favorites.containsKey(img.imgId))
                      favorites.remove(img.imgId);
                  }),
              child: Container(
                height: 35.0,
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                color: colorDarkBlue.withAlpha(50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
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

  Widget _photosGrid(ImagesBloc imagesBloc) {
    return StreamBuilder<List<ImageUnsplash>>(
      stream: imagesBloc.allImages,
      initialData: List<ImageUnsplash>(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: true,
              snap: true,
              floating: true,
              elevation: 8.0,
              title: Text('Unsplash Gallery'),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(left: 2.0, right: 2.0),
              sliver: SliverStaggeredGrid.countBuilder(
                staggeredTileBuilder: (int index) =>
                    StaggeredTile.count(2, index.isEven ? 3 : 2),
                itemBuilder: (BuildContext context, int index) {
                  var images = snapshot.data;
                  print(
                      'Page = $_pageNumber. Images List length = ${snapshot.data.length}');
                  if (index >= (images.length - 10) && !_isLoading) {
                    _isLoading = true;
                    _apiClient
                        .getAllImages(_pageNumber += 1)
                        .then((imagesList) {
                      imagesBloc.addition.add(imagesList);
                      _isLoading = false;
                    });
                  }
                  return _buildGridTile(index, images[index]);
                },
                crossAxisCount: 4,
                itemCount: snapshot.data == null ? 0 : snapshot.data.length,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final imagesBloc = ImagesProvider.of(context);
    return Scaffold(
      body: FutureBuilder<List<ImageUnsplash>>(
        future: _apiClient.getAllImages(_pageNumber),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          if (snapshot.hasData && _pageNumber == 1)
            imagesBloc.addition.add(snapshot.data);
          return snapshot.hasData
              ? _photosGrid(imagesBloc)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
