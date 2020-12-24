import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hn_app/src/widgets/web.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';

import 'package:hn_app/src/article.dart';
import 'package:hn_app/src/notifiers/hn_api.dart';
import 'package:hn_app/src/notifiers/prefs.dart';
import 'package:hn_app/src/widgets/search.dart';
import 'package:hn_app/src/widgets/headline.dart';
import 'package:hn_app/src/favorites.dart';
import 'package:hn_app/src/pages/favorites.dart';
import 'package:hn_app/src/widgets/loading_info.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ListenableProvider(
          create: (_) => LoadingTabsCount(),
          dispose: (_, value) => value.dispose(),
        ),
        Provider(
          create: (context) => HackerNews(
            Provider.of<LoadingTabsCount>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PrefsNotifier(),
        ),
        Provider(
          create: (_) => MyDatabase(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  static const _primaryColor = Color.fromARGB(255, 255, 102, 0);
  static const _accentColor = Colors.black;

  final _darkTheme = ThemeData.dark().copyWith(
    accentColor: _primaryColor,
    textTheme: ThemeData.dark().textTheme.copyWith(
          caption: TextStyle(color: Colors.white54),
          subtitle1: TextStyle(fontFamily: 'RobotoMono', fontSize: 20.0),
          subtitle2: TextStyle(color: Colors.white),
        ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Hacker News',
      theme: Provider.of<PrefsNotifier>(context).useDarkMode == false
          ? ThemeData(
              primaryColor: _primaryColor,
              accentColor: _accentColor,
              scaffoldBackgroundColor: Colors.white,
              canvasColor: Colors.white,
              // bottom navigation bar
              textTheme: Theme.of(context).textTheme.copyWith(
                    caption: TextStyle(color: Colors.black54),
                    subtitle1:
                        TextStyle(fontFamily: 'RobotoMono', fontSize: 20.0),
                    subtitle2: TextStyle(color: Colors.black),
                  ),
            )
          : _darkTheme,
      darkTheme: _darkTheme,
      home: MyHomePage(),
      routes: {
        '/favorites': (context) => FavoritesPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final _pageController = PageController();

  @override
  void initState() {
    _pageController.addListener(_handlePageChange);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.removeListener(_handlePageChange);
    super.dispose();
  }

  void _handlePageChange() {
    setState(() => _currentIndex = _pageController.page.round());
  }

  @override
  Widget build(BuildContext context) {
    final hn = Provider.of<HackerNews>(context);
    final tabs = hn.tabs;
    final currentTab = tabs[_currentIndex];

    if (currentTab.articles.isEmpty && currentTab.isLoading == false) {
      // New tab with no data. Let's fetch some.
      Future(() => currentTab.refresh());
    }

    return Scaffold(
      appBar: AppBar(
        title: Headline(
          text: currentTab.name,
          index: _currentIndex,
        ),
        leading: Consumer<LoadingTabsCount>(
          // consumer to not rebuild the whole tree
          builder: (context, loading, _) => AnimatedSwitcher(
            duration: Duration(milliseconds: 250),
            child: loading.value > 0
                ? LoadingInfo(loading)
                : IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final searchedArticle = await showSearch(
                context: context,
                delegate: ArticleSearch(hn.allArticles),
              );
              if (searchedArticle?.url != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HackerNewsWebPage(
                      url: searchedArticle.url,
                      title: searchedArticle.title,
                    ),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _showPrefsSheet(context),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'HackerNews',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Favorites'),
              onTap: () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      FavoritesPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: animation.drive(
                        Tween(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))
                            .chain(CurveTween(curve: Curves.easeInOutQuart)),
                      ),
                      child: child,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: tabs.length,
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
          value: tabs[index],
          child: _TabPage(index: index),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          for (final tab in tabs)
            BottomNavigationBarItem(
              icon: Icon(tab.icon),
              title: Text(tab.name),
            )
        ],
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          );
          setState(() => _currentIndex = index);
        },
      ),
    );
  }

  void _showPrefsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Preferences'),
            automaticallyImplyLeading: false,
            elevation: 0.0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            textTheme: Theme.of(context).textTheme,
          ),
          body: Consumer<PrefsNotifier>(
            builder: (_, prefs, __) => Column(
              children: <Widget>[
                ListTile(
                  title: Text('Show story web view'),
                  trailing: Switch(
                    value: prefs.showWebView,
                    onChanged: (newValue) => prefs.showWebView = newValue,
                  ),
                ),
                ListTile(
                  title: Text('Always use dark mode'),
                  trailing: Switch(
                    value: prefs.useDarkMode,
                    onChanged: (newValue) => prefs.useDarkMode = newValue,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ArticleWidget extends StatelessWidget {
  final Article article;

  _ArticleWidget({
    Key key,
    @required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: PageStorageKey(article.title),
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
      child: ExpansionTile(
        title: Text(article.title),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    FlatButton(
                      child: Text('${article.descendants} comments'),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HackerNewsCommentPage(id: article.id),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    article.url != null
                        ? IconButton(
                            icon: Icon(Icons.launch),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HackerNewsWebPage(
                                  url: article.url,
                                  title: article.title,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(height: 50.0),
                    SizedBox(width: 16.0),
                    Consumer<MyDatabase>(
                      builder: (_, database, __) => StreamBuilder<bool>(
                        stream: database.isFavorite(article.id),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data == true) {
                            return IconButton(
                              icon: Icon(Icons.star),
                              onPressed: () =>
                                  database.removeFavorite(article.id),
                            );
                          } else {
                            return IconButton(
                              icon: Icon(Icons.star_border),
                              onPressed: () => database.addFavorite(article),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Consumer<PrefsNotifier>(
                  builder: (_, prefs, __) {
                    if (article.url != null && prefs.showWebView == true) {
                      return Container(
                        height: 200.0,
                        child: WebView(
                          initialUrl: article.url,
                          javascriptMode: JavascriptMode.unrestricted,
                          gestureRecognizers: Set()
                            ..add(Factory<VerticalDragGestureRecognizer>(
                                () => VerticalDragGestureRecognizer())),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabPage extends StatelessWidget {
  final int index;

  _TabPage({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HackerNewsTab>(
      builder: (_, tab, __) {
        if (tab.isLoading && tab.articles.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: tab.refresh,
          child: ListView(
            key: PageStorageKey(index),
            children: <Widget>[
              for (final article in tab.articles)
                _ArticleWidget(article: article),
            ],
          ),
        );
      },
    );
  }
}
