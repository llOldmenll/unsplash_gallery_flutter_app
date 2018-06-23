import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:unsplash_gallery_flutter_app/models/image.dart';
import 'package:unsplash_gallery_flutter_app/colors.dart';
import 'package:unsplash_gallery_flutter_app/models/images_provider.dart';
import 'package:unsplash_gallery_flutter_app/data/network/unsplash_api_client.dart';
import 'package:unsplash_gallery_flutter_app/models/images_bloc.dart';

class PagerPage extends StatefulWidget {
  static final tag = 'pager_page';
  List<ImageUnsplash> _initialImages;
  int _initialPage;

  PagerPage(this._initialImages, this._initialPage);

  @override
  _PagerPageState createState() =>
      _PagerPageState(_initialImages, _initialPage);
}

class _PagerPageState extends State<PagerPage> {
  List<ImageUnsplash> _initialImages;
  int _initialPage;
  UnsplashApiClient _apiClient = UnsplashApiClient();
  bool _isLoading = false;

  _PagerPageState(this._initialImages, this._initialPage);

  Widget _buildFooter(ImageUnsplash img) {
    return GestureDetector(
      onTap: () => setState(() => img.isFavorite = !img.isFavorite),
      child: Container(
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
        height: 56.0,
        color: colorDarkBlue.withAlpha(40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 48.0,
              height: 48.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: CachedNetworkImageProvider(img.authorAvatar),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
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
              img.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: img.isFavorite ? Colors.red : colorWhite,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPagerItem(ImageUnsplash img) {
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

  void loadNextPage(ImagesBloc imagesBloc, int nextPage) {
    _isLoading = true;
    _apiClient.getAllImages(nextPage).then((imagesList) {
      imagesBloc.addition.add(imagesList);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final imagesBloc = ImagesProvider.of(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: colorDarkBlue,
            child: StreamBuilder(
              initialData: _initialImages,
              stream: imagesBloc.allImages,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return PageView.builder(
                  controller: PageController(initialPage: _initialPage),
                  itemBuilder: (BuildContext context, int index) {
                    List<ImageUnsplash> images = snapshot.data;
//                print(
//                    'Page = ${images.length ~/ 20}. Images List length = ${images.length}');
                    if (index >= (images.length - 5) && !_isLoading) {
                      loadNextPage(imagesBloc, images.length ~/ 20 + 1);
                    }
                    return _buildPagerItem(images[index]);
                  },
                );
              },
            ),
          ),
          Positioned(
            top: Theme.of(context).platform == TargetPlatform.iOS ? 32.0 : 26.0,
            left: 4.0,
            child: BackButton(color: colorWhite),
          ),
        ],
      ),
    );
  }
}
