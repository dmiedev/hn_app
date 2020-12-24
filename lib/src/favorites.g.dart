// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Favorite extends DataClass implements Insertable<Favorite> {
  final int id;
  final String url;
  final String title;
  final String category;
  Favorite(
      {@required this.id,
      @required this.url,
      @required this.title,
      this.category});
  factory Favorite.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Favorite(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      url: stringType.mapFromDatabaseResponse(data['${effectivePrefix}url']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      category: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}category']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    return map;
  }

  FavoritesCompanion toCompanion(bool nullToAbsent) {
    return FavoritesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
    );
  }

  factory Favorite.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Favorite(
      id: serializer.fromJson<int>(json['id']),
      url: serializer.fromJson<String>(json['url']),
      title: serializer.fromJson<String>(json['title']),
      category: serializer.fromJson<String>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'url': serializer.toJson<String>(url),
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<String>(category),
    };
  }

  Favorite copyWith({int id, String url, String title, String category}) =>
      Favorite(
        id: id ?? this.id,
        url: url ?? this.url,
        title: title ?? this.title,
        category: category ?? this.category,
      );
  @override
  String toString() {
    return (StringBuffer('Favorite(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('title: $title, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(url.hashCode, $mrjc(title.hashCode, category.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Favorite &&
          other.id == this.id &&
          other.url == this.url &&
          other.title == this.title &&
          other.category == this.category);
}

class FavoritesCompanion extends UpdateCompanion<Favorite> {
  final Value<int> id;
  final Value<String> url;
  final Value<String> title;
  final Value<String> category;
  const FavoritesCompanion({
    this.id = const Value.absent(),
    this.url = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
  });
  FavoritesCompanion.insert({
    this.id = const Value.absent(),
    @required String url,
    @required String title,
    this.category = const Value.absent(),
  })  : url = Value(url),
        title = Value(title);
  static Insertable<Favorite> custom({
    Expression<int> id,
    Expression<String> url,
    Expression<String> title,
    Expression<String> category,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (url != null) 'url': url,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
    });
  }

  FavoritesCompanion copyWith(
      {Value<int> id,
      Value<String> url,
      Value<String> title,
      Value<String> category}) {
    return FavoritesCompanion(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      category: category ?? this.category,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    return map;
  }
}

class $FavoritesTable extends Favorites
    with TableInfo<$FavoritesTable, Favorite> {
  final GeneratedDatabase _db;
  final String _alias;
  $FavoritesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _urlMeta = const VerificationMeta('url');
  GeneratedTextColumn _url;
  @override
  GeneratedTextColumn get url => _url ??= _constructUrl();
  GeneratedTextColumn _constructUrl() {
    return GeneratedTextColumn(
      'url',
      $tableName,
      false,
    );
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      false,
    );
  }

  final VerificationMeta _categoryMeta = const VerificationMeta('category');
  GeneratedTextColumn _category;
  @override
  GeneratedTextColumn get category => _category ??= _constructCategory();
  GeneratedTextColumn _constructCategory() {
    return GeneratedTextColumn(
      'category',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, url, title, category];
  @override
  $FavoritesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'favorites';
  @override
  final String actualTableName = 'favorites';
  @override
  VerificationContext validateIntegrity(Insertable<Favorite> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url'], _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title'], _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category'], _categoryMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Favorite map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Favorite.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $FavoritesTable createAlias(String alias) {
    return $FavoritesTable(_db, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $FavoritesTable _favorites;
  $FavoritesTable get favorites => _favorites ??= $FavoritesTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [favorites];
}
