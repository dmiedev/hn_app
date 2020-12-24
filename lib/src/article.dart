import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:hn_app/src/serializers.dart';

part 'article.g.dart';

abstract class Article implements Built<Article, ArticleBuilder> {
  static Serializer<Article> get serializer => _$articleSerializer;

  int get id;

  @nullable
  bool get deleted;

  /// This is the type of the article.
  ///
  /// It can be any of these: "job", "story", "comment", "poll", or "pollopt".
  String get type;

  String get by;

  int get time;

  @nullable
  String get text;

  @nullable
  bool get dead;

  @nullable
  int get parent;

  @nullable
  int get poll;

  BuiltList<int> get kids;

  @nullable
  String get url;

  @nullable
  int get score;

  @nullable
  String get title;

  BuiltList<int> get parts;

  @nullable
  int get descendants;

  Article._();
  factory Article([void Function(ArticleBuilder) updates]) = _$Article;
}

List<int> parseArticleIds(String json) {
  final parsed = jsonDecode(json); // string -> list
  final listOfIds = List<int>.from(parsed); // list<dynamic> -> list<int>
  return listOfIds;
}

Article parseArticle(String json) {
  final parsed = jsonDecode(json); // string -> map
  final article = standardSerializers.deserializeWith(
    Article.serializer,
    parsed,
  ); // map -> object
  return article;
}
