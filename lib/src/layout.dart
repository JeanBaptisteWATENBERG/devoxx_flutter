import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Layout extends StatelessWidget {
  String title;
  Widget body;

  Layout();

  Layout setPage({title, body}) {
    this.title = title;
    this.body = body;
    return this;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(title)),
      drawer: new Drawer(
          child: new ListView(children: <Widget>[
            new DrawerHeader(
                decoration: new BoxDecoration(color: Colors.amber),
                child: new Markdown(data: '**Devoxx FR** \n===\n unoffical *fluter* app')
            ),
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
          ])
      ),
      body: body,
    );
  }

}