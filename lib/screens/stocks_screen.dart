import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:port_viewer/common/utils.dart';

class StocksScreen extends StatefulWidget {
  @override
  _StocksScreenState createState() => _StocksScreenState();
}

class _StocksScreenState extends State<StocksScreen> {
  Future<List<dynamic>> _stocks;
  String _portfolio;
  var isInit = true;

  Future<List<dynamic>> getStocks(BuildContext context) async {
    _portfolio = ModalRoute.of(context).settings.arguments as String;
    final url = Uri.http('localhost:5000', '/api/port/$_portfolio');
    final response = await get(url);
    return json.decode(response.body) as List<dynamic>;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      _stocks = getStocks(context);
      isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_portfolio)),
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
                        onTap: () => Navigator.of(context).pushNamed(
                          "PositionsScreen",
                          arguments: {'port': snapshot.data[i]['port'],
                          'stock': snapshot.data[i]['stock']}
                        ),
                      );
                    })
                : Center(child: CircularProgressIndicator());
          }),
    );
  }
}
