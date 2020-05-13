import 'package:flutter/material.dart';
import 'package:port_viewer/common/utils.dart';

class PositionsScreen extends StatefulWidget {
  final String port;
  final String stock;

  PositionsScreen(this.port, this.stock);

  @override
  _PositionsScreenState createState() => _PositionsScreenState();
}

class _PositionsScreenState extends State<PositionsScreen> {
  Future<List<dynamic>> _positions;

  @override
  void initState() {
    super.initState();
    _positions = getData('/positions/${widget.port}/${widget.stock}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.port}/${widget.stock}"),
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
                          trailing: Text(
                              '${currency.format(snapshot.data[i]['proceeds'])}'),
                        );
                      })
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            }));
  }
}
