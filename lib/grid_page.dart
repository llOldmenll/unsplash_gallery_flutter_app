import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GridPage extends StatefulWidget {
  @override
  createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  static const images = [
    'https://images.unsplash.com/photo-1527623976783-97861c6feff6?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=2901a95f0d1db7c86f3257661cbf849a&auto=format&fit=crop&w=2100&q=80',
    'https://images.unsplash.com/photo-1511445253557-ea91bb5007dc?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=83d7c88bc4d8aa7c5825f3dc3b6f1403&auto=format&fit=crop&w=934&q=80',
    'https://images.unsplash.com/photo-1491719302159-fcdf021abd5c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=edec06b3daef51c2ad631da14044445e&auto=format&fit=crop&w=2146&q=80',
    'https://images.unsplash.com/photo-1496348323715-c11f0fc6aeed?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=c0ca46c79b905ff053eb904a86c3b1cc&auto=format&fit=crop&w=1294&q=80',
    'https://images.unsplash.com/photo-1527623976783-97861c6feff6?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=2901a95f0d1db7c86f3257661cbf849a&auto=format&fit=crop&w=2100&q=80',
    'https://images.unsplash.com/photo-1511445253557-ea91bb5007dc?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=83d7c88bc4d8aa7c5825f3dc3b6f1403&auto=format&fit=crop&w=934&q=80',
    'https://images.unsplash.com/photo-1491719302159-fcdf021abd5c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=edec06b3daef51c2ad631da14044445e&auto=format&fit=crop&w=2146&q=80',
    'https://images.unsplash.com/photo-1496348323715-c11f0fc6aeed?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=c0ca46c79b905ff053eb904a86c3b1cc&auto=format&fit=crop&w=1294&q=80',
    'https://images.unsplash.com/photo-1527623976783-97861c6feff6?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=2901a95f0d1db7c86f3257661cbf849a&auto=format&fit=crop&w=2100&q=80',
    'https://images.unsplash.com/photo-1511445253557-ea91bb5007dc?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=83d7c88bc4d8aa7c5825f3dc3b6f1403&auto=format&fit=crop&w=934&q=80',
    'https://images.unsplash.com/photo-1491719302159-fcdf021abd5c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=edec06b3daef51c2ad631da14044445e&auto=format&fit=crop&w=2146&q=80',
    'https://images.unsplash.com/photo-1496348323715-c11f0fc6aeed?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=c0ca46c79b905ff053eb904a86c3b1cc&auto=format&fit=crop&w=1294&q=80',
    'https://images.unsplash.com/photo-1527623976783-97861c6feff6?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=2901a95f0d1db7c86f3257661cbf849a&auto=format&fit=crop&w=2100&q=80',
    'https://images.unsplash.com/photo-1511445253557-ea91bb5007dc?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=83d7c88bc4d8aa7c5825f3dc3b6f1403&auto=format&fit=crop&w=934&q=80',
    'https://images.unsplash.com/photo-1491719302159-fcdf021abd5c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=edec06b3daef51c2ad631da14044445e&auto=format&fit=crop&w=2146&q=80',
    'https://images.unsplash.com/photo-1496348323715-c11f0fc6aeed?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=c0ca46c79b905ff053eb904a86c3b1cc&auto=format&fit=crop&w=1294&q=80',
    'https://images.unsplash.com/photo-1527623976783-97861c6feff6?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=2901a95f0d1db7c86f3257661cbf849a&auto=format&fit=crop&w=2100&q=80',
    'https://images.unsplash.com/photo-1511445253557-ea91bb5007dc?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=83d7c88bc4d8aa7c5825f3dc3b6f1403&auto=format&fit=crop&w=934&q=80',
    'https://images.unsplash.com/photo-1491719302159-fcdf021abd5c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=edec06b3daef51c2ad631da14044445e&auto=format&fit=crop&w=2146&q=80',
    'https://images.unsplash.com/photo-1496348323715-c11f0fc6aeed?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=c0ca46c79b905ff053eb904a86c3b1cc&auto=format&fit=crop&w=1294&q=80',
    'https://images.unsplash.com/photo-1527623976783-97861c6feff6?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=2901a95f0d1db7c86f3257661cbf849a&auto=format&fit=crop&w=2100&q=80',
    'https://images.unsplash.com/photo-1511445253557-ea91bb5007dc?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=83d7c88bc4d8aa7c5825f3dc3b6f1403&auto=format&fit=crop&w=934&q=80',
    'https://images.unsplash.com/photo-1491719302159-fcdf021abd5c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=edec06b3daef51c2ad631da14044445e&auto=format&fit=crop&w=2146&q=80',
    'https://images.unsplash.com/photo-1496348323715-c11f0fc6aeed?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=c0ca46c79b905ff053eb904a86c3b1cc&auto=format&fit=crop&w=1294&q=80',
    'https://images.unsplash.com/photo-1527623976783-97861c6feff6?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=2901a95f0d1db7c86f3257661cbf849a&auto=format&fit=crop&w=2100&q=80',
    'https://images.unsplash.com/photo-1511445253557-ea91bb5007dc?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=83d7c88bc4d8aa7c5825f3dc3b6f1403&auto=format&fit=crop&w=934&q=80',
    'https://images.unsplash.com/photo-1491719302159-fcdf021abd5c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=edec06b3daef51c2ad631da14044445e&auto=format&fit=crop&w=2146&q=80',
    'https://images.unsplash.com/photo-1496348323715-c11f0fc6aeed?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=c0ca46c79b905ff053eb904a86c3b1cc&auto=format&fit=crop&w=1294&q=80',
  ];

  List<Container> _buildGridTileList() {
    return new List<Container>.generate(
      images.length,
      (int index) => new Container(
            child: CachedNetworkImage(
              imageUrl: images[index],
              fit: BoxFit.cover,
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
//            forceElevated: true,
            snap: true,
            floating: true,
            elevation: 8.0,
            title: Text('Grid Test'),
          ),
          SliverStaggeredGrid.countBuilder(
//            mainAxisSpacing: 4.0,
//            crossAxisSpacing: 4.0,

//            children: _buildGridTileList(),
//            maxCrossAxisExtent: 300.0,
            staggeredTileBuilder: (int index) =>
                new StaggeredTile.count(2, index.isEven ? 4 : 3),
            itemBuilder: (BuildContext context, int index) => new Container(
                  padding: EdgeInsets.all(4.0),
                  child: CachedNetworkImage(
                    imageUrl: images[index],
                    fit: BoxFit.cover,
                  ),
                ),
            crossAxisCount: 4,
            itemCount: images.length,
          ),
        ],
      ),
    );
  }
}
