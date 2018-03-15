import 'package:devoxx_flutter/src/state_provider.dart';
import 'package:devoxx_flutter/src/utils/searchable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Layout extends StatefulWidget {
  Layout();

  @override
  State<StatefulWidget> createState() => new _Layout();
}

class _Layout extends State<Layout> {
  bool _isSearching = false;
  Widget _body;

  @override
  Widget build(BuildContext context) {
    var stateProvider = StateProvider.of(context);
    // Keep actual body in cache in case of navigation
    _body = stateProvider.body;
    var searchBar = _buildSearchBar();
    var bar = _buildAppBar();
    return new Scaffold(
      appBar: _isSearching ? searchBar : bar,
      drawer: new Drawer(
          child: new ListView(children: <Widget>[
        new DrawerHeader(
            decoration: new BoxDecoration(color: Colors.amber),
            child: new Markdown(
                data: '**Devoxx FR** \n===\n unoffical *fluter* app')),
        new ListTile(
          leading: new Icon(Icons.list),
          title: new Text('Schedule'),
          onTap: () {
            Navigator.of(context).pushNamed('/');
          },
        ),
        new ListTile(
          leading: new Icon(Icons.person),
          title: new Text('Speakers'),
          onTap: () {
            Navigator.of(context).pushNamed('/speakers');
          },
        ),
        new ListTile(
          leading: new Icon(Icons.favorite),
          title: new Text('Pinned talks'),
          onTap: () {
            Navigator.of(context).pushNamed('/talks/pinned');
          },
        )
      ])),
      body: _body,
    );
  }

  AppBar _buildAppBar() {
    var stateProvider = StateProvider.of(context);
    return new AppBar(title: new Text(stateProvider.title), actions: <Widget>[
      new IconButton(
        icon: const Icon(Icons.search),
        onPressed: _handleSearchBegin,
        tooltip: 'Search',
      )
    ]);
  }

  AppBar _buildSearchBar() {
    return new AppBar(
      leading: new IconButton(
        icon: const Icon(Icons.arrow_back),
        color: Theme.of(context).accentColor,
        onPressed: _handleSearchEnd,
        tooltip: 'Back',
      ),
      title: new TextField(
        controller: (_body as Searchable).getSearchQuery(),
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Search',
        ),
      ),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }

  void _handleSearchBegin() {
    ModalRoute.of(context).addLocalHistoryEntry(new LocalHistoryEntry(
      onRemove: () {
        setState(() {
          _isSearching = false;
          (_body as Searchable).getSearchQuery().clear();
        });
      },
    ));
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    Navigator.pop(context);
  }

}
