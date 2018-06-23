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
  UnsplashApiClient _apiClient = UnsplashApiClient();
  int _pageNumber = 0;
  bool _isLoading = false;

  Container _buildGridTile(
      int position, List<ImageUnsplash> images, ImagesBloc imagesBloc) {
    var img = images[position];
    return Container(
//      key: Key(img.imgId),
      padding: const EdgeInsets.all(2.0),
      child: Stack(
        children: <Widget>[
          Positioned(
            child: GestureDetector(
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            PagerPage(images, position)),
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
              onTap: () => setState(() => img.isFavorite = !img.isFavorite),
              child: Container(
                height: 35.0,
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
                      img.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: img.isFavorite ? Colors.red : colorWhite,
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
        if (snapshot.hasData && snapshot.data.length > 0)
          return OrientationBuilder(
            builder: (context, orientation) {
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
                      staggeredTileBuilder: (int index) => StaggeredTile.count(
                          orientation == Orientation.portrait ? 2 : 1,
                          orientation == Orientation.portrait
                              ? (index.isEven ? 3 : 2)
                              : (index.isEven ? 2 : 1)),
                      itemBuilder: (BuildContext context, int index) {
                        List<ImageUnsplash> images = snapshot.data;
                        _pageNumber = images.length ~/ 20;
//                    print(
//                        'Page = $_pageNumber. Images List length = ${images.length}');
                        if (index >= (images.length - 10) && !_isLoading) {
                          _loadNextPage(imagesBloc);
                        }
                        return _buildGridTile(index, images, imagesBloc);
                      },
                      crossAxisCount:
                          orientation == Orientation.portrait ? 4 : 4,
                      itemCount: snapshot.data.length,
                    ),
                  ),
                ],
              );
            },
          );
        else
          return Center(child: CircularProgressIndicator());
      },
    );
  }

  _loadNextPage(ImagesBloc imagesBloc) {
    _isLoading = true;
    _apiClient.getAllImages(_pageNumber + 1).then((imagesList) {
      imagesBloc.addition.add(imagesList);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final imagesBloc = ImagesProvider.of(context);
    if (_pageNumber == 0) _loadNextPage(imagesBloc);
    return Scaffold(body: _photosGrid(imagesBloc));
  }
}
