import 'package:hn_app/src/article.dart';
import 'package:moor/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:moor/moor.dart';
import 'dart:io';

part 'favorites.g.dart';

class Favorites extends Table {
  IntColumn get id => integer()();
  TextColumn get url => text()();
  TextColumn get title => text()();
  TextColumn get category => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [Favorites])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Stream<List<Favorite>> get allFavorites => select(favorites).watch();

  Stream<bool> isFavorite(int id) {
    return (select(favorites)..where((favorite) => favorite.id.equals(id)))
        .watch()
        .map((favoritesList) => favoritesList.isNotEmpty);
  }

  void addFavorite(Article article) {
    into(favorites).insert(
      FavoritesCompanion(
        id: Value(article.id),
        url: Value(article.url),
        title: Value(article.title),
        category: Value(article.type),
      ),
    );
  }

  void removeFavorite(int id) =>
      (delete(favorites)..where((favorite) => favorite.id.equals(id))).go();
}
