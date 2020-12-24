import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hn_app/src/favorites.dart';
import 'package:hn_app/src/widgets/web.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: Consumer<MyDatabase>(
        builder: (context, database, _) => StreamBuilder<List<Favorite>>(
          stream: database.allFavorites,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong...'));
            }
            if (snapshot.hasData) {
              if (snapshot.data.isEmpty) {
                return Center(child: Text('No favorites'));
              }
              return ListView(
                children: <Widget>[
                  for (final favorite in snapshot.data)
                    ListTile(
                      title: Text(favorite.title),
                      trailing: IntrinsicWidth(
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.launch),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HackerNewsWebPage(
                                    url: favorite.url,
                                    title: favorite.title,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () =>
                                  database.removeFavorite(favorite.id),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
