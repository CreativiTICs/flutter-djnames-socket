import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_names/models/djs.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Djs> djs = [
    Djs(id: '1', name: 'Carl Cox', votes: 5),
    Djs(id: '2', name: 'Hot Since 82', votes: 4),
    Djs(id: '3', name: 'Ronnie Spiteri', votes: 5),
    Djs(id: '4', name: 'Miguel Lobo', votes: 3),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          'DJ Name',
          style: TextStyle(color: Colors.teal),
        ),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
          itemCount: djs.length, itemBuilder: (context, i) => _djsTile(djs[i])),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
        elevation: 1,
        onPressed: addNewDj,
      ),
    );
  }

  Widget _djsTile(Djs dj) {
    return Dismissible(
      key: Key(dj.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('direction: $direction');
        print('id: ${dj.id}');
      },
      background: Container(
        padding: EdgeInsets.only(left: 20),
        color: Colors.red,
        child: Row(
          children: [
            Text(
              'Delete',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 20),
            Icon(Icons.delete_sweep, color: Colors.white)
          ],
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(dj.name.substring(0, 1)),
          backgroundColor: Colors.teal[100],
        ),
        title: Text(dj.name),
        trailing: Text(
          '${dj.votes}',
          style: TextStyle(fontSize: 20),
        ),
        onTap: () => print(dj.name),
      ),
    );
  }

  addNewDj() {
    final textController = new TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Add New DJ:'),
          content: TextField(
            controller: textController,
          ),
          actions: [
            MaterialButton(
                child: Text('Add'),
                elevation: 5,
                textColor: Colors.white,
                color: Colors.teal,
                onPressed: () => addDjToList(textController.text))
          ],
        ),
      );
    }
    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text('Add New DJ:'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Add'),
                onPressed: () => addDjToList(textController.text),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('Close'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  void addDjToList(String name) {
    print(name);
    if (name.length > 1) {
      this
          .djs
          .add(new Djs(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }

    Navigator.pop(context);
  }
}
