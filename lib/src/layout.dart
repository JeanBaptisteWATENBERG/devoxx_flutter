import 'package:devoxx_flutter/src/screens/slot_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Layout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Devoxx FR - Schedule')),
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
      body: new SlotListScreen(),
    );
  }

}