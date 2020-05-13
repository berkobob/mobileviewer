import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:port_viewer/common/utils.dart';

class PortfoliosScreen extends StatefulWidget {
  @override
  _PortfoliosScreenState createState() => _PortfoliosScreenState();
}

class _PortfoliosScreenState extends State<PortfoliosScreen> {
  Future _ports;
 

  Future<List<dynamic>> getPorts() async {
    final url = Uri.http("localhost:5000", "/api/");
    final response = await http.get(url);
    return json.decode(response.body) as List<dynamic>;
  }

  @override
  void initState() {
    super.initState();
    _ports = getPorts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Portfolios')),
        body: FutureBuilder(
          future: _ports,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('none');
              case ConnectionState.active:
                return Text('active');
              case ConnectionState.waiting:
                return Text('waiting');
              case ConnectionState.done:
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        title: Text(snapshot.data[i]['name']),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Stocks:${snapshot.data[i]['stocks']}'),
                            Text('Positions:${snapshot.data[i]['positions']}'),
                            Text('Open:${snapshot.data[i]['open']}'),
                          ],
                        ),
                        trailing: Text(
                            '\$${currency.format(snapshot.data[i]['proceeds'])}'),
                        onTap: () => Navigator.of(context).pushNamed(
                            "StocksScreen",
                            arguments: snapshot.data[i]['name']),
                      );
                    });
              default:
                return Text('default');
            }
          },
        ));
  }
}
