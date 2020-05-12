import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PortfoliosScreen extends StatefulWidget {
  @override
  _PortfoliosScreenState createState() => _PortfoliosScreenState();
}

class _PortfoliosScreenState extends State<PortfoliosScreen> {
  Future _ports;
  final curr = NumberFormat("#,##0", 'en-UK');

  Future<List<dynamic>> getPorts() async {
    final url = Uri.http("localhost:5000", "/api/");
    // const url = 'localhost:5000/api/';
    // const url = "http://192.168.86.35:5000/api/";
    // const url = "https://lever.family/api/";
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
        body: Center(
          child: FutureBuilder(
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
                        trailing: Text('\$${curr.format(snapshot.data[i]['proceeds'])}'),
                        onTap: () {print(snapshot.data[i]['name']);},
                      );
                    }
                  );
                default:
                  return Text('default');
              }
              // Center(child: Text("Code: " + getPorts().toString()));
            },
          ),
        ));
  }
}
