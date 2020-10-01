import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:band_names/models/djs.dart';
import 'package:band_names/services/socket_services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Dj> djs = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketServices>(context, listen: false);

    socketService.socket.on('active-djs', _handleActiveDjs);

    super.initState();
  }

  _handleActiveDjs(dynamic payload) {
    this.djs = (payload as List).map((dj) => Dj.fromMap(dj)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketServices>(context, listen: false);
    socketService.socket.off('active-djs');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketServices>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.Online)
                ? Icon(Icons.check_circle, color: Colors.teal)
                : Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
        title: Text(
          'DJ Name',
          style: TextStyle(color: Colors.teal),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
                itemCount: djs.length,
                itemBuilder: (context, i) => _djsTile(djs[i])),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
        elevation: 1,
        onPressed: addNewDj,
      ),
    );
  }

  Widget _djsTile(Dj dj) {
    final socketService = Provider.of<SocketServices>(context, listen: false);

    return Dismissible(
      key: Key(dj.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => socketService.emit('delete-dj', {'id': dj.id}),
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
        onTap: () => socketService.emit('vote-dj', {'id': dj.id}),
      ),
    );
  }

  addNewDj() {
    final textController = new TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (_) => AlertDialog(
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
      builder: (_) => CupertinoAlertDialog(
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
      ),
    );
  }

  void addDjToList(String name) {
    if (name.length > 1) {
      final socketService = Provider.of<SocketServices>(context, listen: false);
      socketService.emit('add-dj', {'name': name});
    }

    Navigator.pop(context);
  }

  // Mostrar Gráfica
  Widget _showGraph() {
    Map<String, double> dataMap = new Map();
    djs.forEach((dj) {
      dataMap.putIfAbsent(dj.name, () => dj.votes.toDouble());
    });

    final List<Color> colorList = [
      Colors.teal,
      Colors.blue,
      Colors.teal[100],
      Colors.blue[200],
      Colors.teal[200],
      Colors.blue[100],
    ];
    return Container(
        width: double.infinity,
        height: 200,
        child: PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800),
          chartRadius: MediaQuery.of(context).size.width / 3.2,
          colorList: colorList,
          initialAngleInDegree: 1,
          chartType: ChartType.disc,
          ringStrokeWidth: 32,
          centerText: "HYBRID",
          legendOptions: LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.right,
            showLegends: true,
            legendTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          chartValuesOptions: ChartValuesOptions(
            showChartValueBackground: true,
            showChartValues: true,
            showChartValuesInPercentage: true,
            showChartValuesOutside: false,
            chartValueBackgroundColor: Colors.transparent,
          ),
        ));
  }
}
