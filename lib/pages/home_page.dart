import 'dart:io';

import 'package:band_name_app/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../models/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    /*  Band(id: '1', name: 'Metallica', votes: 8),
    Band(id: '2', name: 'Queen', votes: 5),
    Band(id: '3', name: 'Megadeath', votes: 7),
    Band(id: '4', name: 'Los bukis', votes: 8),
    Band(id: '5', name: 'Banda MS', votes: 9)*/
  ];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context,
        listen: false); // not need to check for changes

    socketService.socket.on('active-bands', _handleActiveBands);
    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    this.bands = (payload as List).map((band) => Band.formMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BandNames',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 1,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.ONLINE
                ? Icon(
                    Icons.wifi_outlined,
                    color: Colors.white,
                  )
                : Icon(
                    Icons.wifi_off,
                    color: Colors.red,
                  ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          _showGraph(),
          Expanded(
            child: ListView.builder(
                itemCount: bands.length,
                itemBuilder: (context, index) => _bandTile(bands[index])),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) =>
          socketService.socket.emit('delete-band', {'id': band.id}),
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
        onTap: () => socketService.socket.emit('vote-band', {'id': band.id}),
      ),
    );
  }

  void addNewBand() {
    final textFieldController = TextEditingController();

    if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("New Band name:"),
                content: TextField(
                  controller: textFieldController,
                ),
                actions: <Widget>[
                  MaterialButton(
                      elevation: 5,
                      child: Text('Add'),
                      textColor: Colors.blue,
                      onPressed: () => addBandToList(textFieldController.text)),
                ],
              ));
      return;
    }

    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
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
            ));
  }

  void addBandToList(String bandName) {
    if (bandName.length > 1) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket.emit('add-band', {"name": bandName});
      /* setState(() {

        bands.add(Band(id: DateTime.now().toString(), name: bandName, votes: 0));
      });*/
    }
    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = new Map();
    // dataMap.putIfAbsent('Flutter', () => 5);
    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });

    final List<Color> colorList = [
      Colors.blue[50]!,
      Colors.blue[200]!,
      Colors.pink[50]!,
      Colors.pink[200]!,
      Colors.yellow[50]!,
      Colors.yellow[200]!,
    ];

    return Container(
        padding: EdgeInsets.only(top: 10),
        width: double.infinity,
        height: 200,
        child: PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800),
          colorList: colorList,
          chartType: ChartType.disc,
          chartValuesOptions: ChartValuesOptions(
              decimalPlaces: 0,
              showChartValues: true,
              showChartValuesInPercentage: true,
              showChartValuesOutside: false,
              chartValueBackgroundColor: Colors.grey[200]),
        ));
  }
}
