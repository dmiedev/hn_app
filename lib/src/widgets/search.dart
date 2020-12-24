import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hn_app/src/article.dart';

class ArticleSearch extends SearchDelegate<Article> {
  final UnmodifiableListView<Article> articles;

  ArticleSearch(this.articles);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = articles.where(
      (article) => article.title.toLowerCase().contains(query.toLowerCase()),
    );

    return ListView(
      children: results.map((article) {
        return ListTile(
          title: Text(article.title),
          leading: Icon(Icons.book),
          subtitle: article.url != null ? Text(article.url) : Container(),
          onTap: () => close(context, article),
        );
      }).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
