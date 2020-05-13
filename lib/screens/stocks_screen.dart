import 'package:flutter/material.dart';
import 'package:port_viewer/common/utils.dart';
import 'package:port_viewer/screens/positions_screen.dart';

class StocksScreen extends StatefulWidget {
  final String port;

  StocksScreen(this.port);

  @override
  _StocksScreenState createState() => _StocksScreenState();
}

class _StocksScreenState extends State<StocksScreen> {
  Future<List<dynamic>> _stocks;

  @override
  void initState() {
    super.initState();
    _stocks = getData('/port/${widget.port}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.port)),
      body: FutureBuilder(
          future: _stocks,
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                          title: Text(snapshot.data[i]['stock']),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Open: ${snapshot.data[i]['open']}'),
                              Text('Closed: ${snapshot.data[i]['closed']}'),
                            ],
                          ),
                          trailing: Text(
                              '${currency.format(snapshot.data[i]['proceeds'])}'),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PositionsScreen(
                                      snapshot.data[i]['port'],
                                      snapshot.data[i]['stock']))));
                    })
                : Center(child: CircularProgressIndicator());
          }),
    );
  }
}
