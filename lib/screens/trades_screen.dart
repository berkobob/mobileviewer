import 'package:flutter/material.dart';
import 'package:port_viewer/common/utils.dart';

class TradesScreen extends StatefulWidget {
  final String id;
  final String position;

  TradesScreen(this.id, this.position);

  @override
  _TradesScreenState createState() => _TradesScreenState();
}

class _TradesScreenState extends State<TradesScreen> {
  Future<List<dynamic>> _trades;

  @override
  void initState() {
    super.initState();
    _trades = getData('/trades/${widget.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.position)),
        body: FutureBuilder(
            future: _trades,
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.done
                  ? ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, i) => ListTile(
                        title: Text(snapshot.data[i]['stock']),
                        trailing: Text(
                          '${currency.format(snapshot.data[i]['proceeds'])}',
                          textAlign: TextAlign.right,
                        ),
                        subtitle: Row(children: <Widget>[
                          Flexible(
                            flex: 5,
                            fit: FlexFit.tight,
                            child: Text('${snapshot.data[i]["quantity"]} @ ${snapshot.data[i]["price"]}'),
                          )
                        ],),
                      ),
                    )
                  : Center(child: CircularProgressIndicator());
            }));
  }
}
