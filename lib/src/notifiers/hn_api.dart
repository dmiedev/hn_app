import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hn_app/src/article.dart';

enum StoriesType {
  topStories,
  newStories,
}

/// A global cache of articles.
final _cachedArticles = {};

/// The number of tabs that are currently loading.
class LoadingTabsCount extends ValueNotifier<int> {
  LoadingTabsCount() : super(0);
}

/// This class encapsulates the app's communication with the Hacker News API
/// and which articles are fetched in which [tabs].
class HackerNews {
  List<HackerNewsTab> _tabs;
  UnmodifiableListView<HackerNewsTab> get tabs => UnmodifiableListView(_tabs);

  HackerNews(LoadingTabsCount loading) {
    _tabs = [
      HackerNewsTab(
        StoriesType.topStories,
        'Top Stories',
        Icons.arrow_drop_up,
        loading,
      ),
      HackerNewsTab(
        StoriesType.newStories,
        'New Stories',
        Icons.new_releases,
        loading,
      ),
    ];
    // scheduleMicrotask(() => _tabs.first.refresh());
  }

  /// Articles from all tabs. De-duplicated.
  UnmodifiableListView<Article> get allArticles => UnmodifiableListView(
      _tabs.expand((tab) => tab.articles).toSet().toList(growable: false));
}

class HackerNewsTab with ChangeNotifier {
  static const _baseUrl = 'https://hacker-news.firebaseio.com/v0/';

  final StoriesType storiesType;

  final String name;

  List<Article> _articles = [];
  UnmodifiableListView<Article> get articles => UnmodifiableListView(_articles);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final IconData icon;

  final LoadingTabsCount loadingTabsCount;

  HackerNewsTab(this.storiesType, this.name, this.icon, this.loadingTabsCount);

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();
    loadingTabsCount.value++;
    final ids = await _getIds(storiesType);
    await _updateArticles(ids);
    _isLoading = false;
    notifyListeners();
    loadingTabsCount.value--;
  }

  Future<Article> _getArticle(int id) async {
    if (_cachedArticles.containsKey(id) == false) {
      final url = '${_baseUrl}item/$id.json';
      final response = await http.get(url);
      if (response.statusCode == 200 && response.body != null) {
        _cachedArticles[id] = parseArticle(response.body);
      } else {
        throw HackerNewsApiException("Article $id couldn't be fetched.");
      }
    }
    return _cachedArticles[id];
  }

  Future<List<int>> _getIds(StoriesType type) async {
    final urlPart = type == StoriesType.topStories ? 'top' : 'new';
    final url = '$_baseUrl${urlPart}stories.json';
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return parseArticleIds(response.body).take(10).toList();
    } else {
      throw HackerNewsApiException("Stories $type couldn't be fetched.");
    }
  }

  Future<void> _updateArticles(List<int> articleIds) async {
    final futureArticles = articleIds
        .map((id) => _getArticle(id))
        .where((article) => article != null);
    _articles = await Future.wait(futureArticles);
  }
}

class HackerNewsApiException implements Exception {
  final String message;

   HackerNewsApiException(this.message);
}
