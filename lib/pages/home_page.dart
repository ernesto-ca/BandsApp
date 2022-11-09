import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 8),
    Band(id: '2', name: 'Queen', votes: 5),
    Band(id: '3', name: 'Megadeath', votes: 7),
    Band(id: '4', name: 'Los bukis', votes: 8),
    Band(id: '5', name: 'Banda MS', votes: 9)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BandNames',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (context, index) => _bandTile(bands[index])),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('direction: $direction');
        //TODO call delete method from server
      },
      background: Container(
        padding: EdgeInsets.only(left: 12.0),
        color: Colors.red,
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Delete Band",
              style: TextStyle(color: Colors.white),
            )),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[300],
        ),
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: TextStyle(fontSize: 20),
        ),
        onTap: () => print(band.name),
      ),
    );
  }

  void addNewBand() {
    final textFieldController = TextEditingController();

    if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("New Band name:"),
              content: TextField(
                controller: textFieldController,
              ),
              actions: <Widget>[
                MaterialButton(
                    elevation: 5,
                    child: Text('Add'),
                    textColor: Colors.blue,
                    onPressed: () {
                      addBandToList(textFieldController.text);
                    }),
              ],
            );
          });
      return;
    }

    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text("New Band Name:"),
            content: CupertinoTextField(
              controller: textFieldController,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Add'),
                onPressed: () => addBandToList(textFieldController.text),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  void addBandToList(String bandName) {
    if (bandName.length > 1) {
      setState(() {
        bands
            .add(Band(id: DateTime.now().toString(), name: bandName, votes: 0));
      });
    }
    Navigator.pop(context);
  }
}
