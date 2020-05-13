import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:port_viewer/common/utils.dart';

class PositionsScreen extends StatefulWidget {
  @override
  _PositionsScreenState createState() => _PositionsScreenState();
}

class _PositionsScreenState extends State<PositionsScreen> {
  Future<List<dynamic>> _positions;
  bool isInit = true;
  String port;
  String stock;

  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      _positions = getPositions(context);
      isInit = false;
    }
  }

  Future<List<dynamic>> getPositions(BuildContext context) async {
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    port = args['port'];
    stock = args['stock'];
    final url = Uri.http('localhost:5000', '/api/positions/$port/$stock');
    final response = await get(url);
    return json.decode(response.body) as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("$port/$stock"),
        ),
        body: FutureBuilder(
            future: _positions,
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.done
                  ? ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                            leading: snapshot.data[i]['closed'] == false
                                ? Icon(Icons.lock_open)
                                : Icon(Icons.lock_outline),
                            title: Text(snapshot.data[i]['position']),
                            trailing: Text('${currency.format(snapshot.data[i]['proceeds'])}'),
                            );
                      })
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            }));
  }
}
