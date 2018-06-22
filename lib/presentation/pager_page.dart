import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:unsplash_gallery_flutter_app/models/image.dart';
import 'package:unsplash_gallery_flutter_app/colors.dart';
import 'package:unsplash_gallery_flutter_app/models/images_provider.dart';

class PagerPage extends StatefulWidget {
  static final tag = 'pager_page';
  List<ImageUnsplash> _initialImages;
  Map<String, ImageUnsplash> _favorites;
  int _initialPage;

  PagerPage(this._initialImages, this._favorites, this._initialPage);

  @override
  _PagerPageState createState() => _PagerPageState(_initialImages, _favorites, _initialPage);
}

class _PagerPageState extends State<PagerPage> {
  List<ImageUnsplash> _initialImages;
  Map<String, ImageUnsplash> _favorites;
  int _initialPage;

  _PagerPageState(this._initialImages, this._favorites, this._initialPage);

  Widget _buildFooter(ImageUnsplash img) {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
      height: 76.0,
      color: colorDarkBlue.withAlpha(40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 55.0,
            height: 55.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                fit: BoxFit.fill,
                image: CachedNetworkImageProvider(img.authorAvatar),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                img.authorName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: colorWhite,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
            ),
          ),
          Icon(
            _favorites.containsKey(img.imgId)
                ? Icons.favorite
                : Icons.favorite_border,
            color: _favorites.containsKey(img.imgId) ? Colors.red : colorWhite,
          ),
        ],
      ),
    );
  }

  Widget _buildPage(ImageUnsplash img) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 0.0,
          right: 0.0,
          top: 0.0,
          bottom: 0.0,
          child: Hero(
            tag: img.imgId,
            child: CachedNetworkImage(imageUrl: img.thumbImgUrl),
          ),
        ),
        Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          child: _buildFooter(img),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final imagesBloc = ImagesProvider.of(context);
    return Scaffold(
      body: Container(
        color: colorDarkBlue,
        child: StreamBuilder(
          initialData: _initialImages,
          stream: imagesBloc.allImages,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return PageView.builder(
                controller: PageController(initialPage: _initialPage),
                itemBuilder: (BuildContext context, int index) =>
                    _buildPage(snapshot.data[index]));
          },
        ),
      ),
    );
  }
}
