import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:unsplash_gallery_flutter_app/data/network/images_loader.dart';

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
  static const platform =
      MethodChannel('unsplash_gallery_flutter_app/save_image');

  UnsplashApiClient _apiClient = UnsplashApiClient();
  List<ImageUnsplash> _initialImages;
  int _initialPage;
  bool _isLoading = false;
  PageController _pageController;
  bool _isSaving = false;

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
          child: _isSaving
              ? Center(child: CircularProgressIndicator())
              : Hero(
                  tag: img.imgId,
                  child: CachedNetworkImage(imageUrl: img.thumbImgUrl)),
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

  _loadNextPage(ImagesBloc imagesBloc, int nextPage) {
    _isLoading = true;
    _apiClient.getAllImages(nextPage).then((imagesList) {
      imagesBloc.addition.add(imagesList);
      _isLoading = false;
    });
  }

  Future<Null> _saveImageLocale(BuildContext context, String directoryName,
      String fileName, Uint8List imgBytes) async {
    String responseStatus;
    Map<String, dynamic> map = {
      'directoryName': directoryName,
      'fileName': fileName,
      'imgBytes': imgBytes
    };

    try {
      responseStatus = await platform.invokeMethod('saveImage', map);
    } on PlatformException catch (e) {
      responseStatus = 'Failed to save image: ${e.message}';
    }

    setState(() => _isSaving = false);
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(responseStatus)));
    print(responseStatus);
  }

  @override
  Widget build(BuildContext context) {
    final imagesBloc = ImagesProvider.of(context);
    return Scaffold(
      body: StreamBuilder(
        initialData: _initialImages,
        stream: imagesBloc.allImages,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Stack(
            children: <Widget>[
              Container(
                color: colorDarkBlue,
                child: PageView.builder(
                  controller: _pageController =
                      PageController(initialPage: _initialPage),
                  itemBuilder: (BuildContext context, int index) {
                    List<ImageUnsplash> images = snapshot.data;
                    if (index >= (images.length - 5) && !_isLoading) {
                      _loadNextPage(imagesBloc, images.length ~/ 20 + 1);
                    }
                    return _buildPagerItem(images[index]);
                  },
                ),
              ),
              Positioned(
                top: Theme.of(context).platform == TargetPlatform.iOS
                    ? 32.0
                    : 26.0,
                left: 4.0,
                child: BackButton(color: colorWhite),
              ),
              Positioned(
                top: Theme.of(context).platform == TargetPlatform.iOS
                    ? 32.0
                    : 26.0,
                right: 4.0,
                child: IconButton(
                  icon: Icon(
                    Icons.file_download,
                    color: colorWhite,
                  ),
                  onPressed: () {
                    if (Theme.of(context).platform == TargetPlatform.android) {
                      setState(() => _isSaving = true);
                      ImageUnsplash img =
                          snapshot.data[_pageController.page.toInt()];
                      ImagesLoader().downloadImage(img.fullImgUrl).then(
                          (answer) => _saveImageLocale(context,
                              'unsplash_flutter_app', img.imgId, answer));
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content:
                              Text("IOS platform hasn't supported yet! :(")));
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
